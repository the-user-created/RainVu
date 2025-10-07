import "package:rain_wise/core/data/local/app_database.dart";
import "package:rain_wise/core/data/local/daos/rainfall_entries_dao.dart";
import "package:rain_wise/features/anomaly_exploration/domain/anomaly_data.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:uuid/uuid.dart";

part "anomaly_exploration_repository.g.dart";

abstract class AnomalyExplorationRepository {
  Future<AnomalyExplorationData> fetchAnomalyData(
    final AnomalyFilter filter,
    final double minAnomalyThreshold,
  );
}

@riverpod
AnomalyExplorationRepository anomalyExplorationRepository(
  final Ref ref,
) {
  final AppDatabase db = ref.watch(appDatabaseProvider);
  return DriftAnomalyExplorationRepository(db.rainfallEntriesDao);
}

class DriftAnomalyExplorationRepository
    implements AnomalyExplorationRepository {
  DriftAnomalyExplorationRepository(this._dao);

  final RainfallEntriesDao _dao;
  static const _uuid = Uuid();

  @override
  Future<AnomalyExplorationData> fetchAnomalyData(
    final AnomalyFilter filter,
    final double minAnomalyThreshold,
  ) async {
    // 1. Fetch historical data and daily totals in parallel.
    final List<List<Object>> results = await Future.wait([
      _dao.getHistoricalDayInfo(),
      _dao.getDailyTotalsInRange(filter.dateRange.start, filter.dateRange.end),
    ]);

    final historicalInfo = results[0] as List<HistoricalDayInfo>;
    final dailyTotals = results[1] as List<DailyTotalWithDate>;

    // 2. Create a lookup map for historical averages.
    final historicalAverages = <String, double>{};
    for (final info in historicalInfo) {
      if (info.yearCount > 0) {
        final key = "${info.month}-${info.day}";
        historicalAverages[key] = info.total / info.yearCount;
      }
    }

    final allAnomalies = <RainfallAnomaly>[];
    final chartPoints = <AnomalyChartPoint>[];

    // 3. Process each day in the range to find anomalies and build chart data.
    for (final dailyData in dailyTotals) {
      final DateTime date = dailyData.date;
      final double actualRainfall = dailyData.total;
      final key = "${date.month}-${date.day}";
      final double averageRainfall = historicalAverages[key] ?? 0.0;

      chartPoints.add(
        AnomalyChartPoint(
          date: date,
          actualRainfall: actualRainfall,
          averageRainfall: averageRainfall,
        ),
      );

      // Don't calculate deviation if there's no historical average.
      if (averageRainfall == 0.0) {
        continue;
      }

      final double deviation = actualRainfall - averageRainfall;
      final double deviationPercentage = (deviation / averageRainfall) * 100;

      if (deviationPercentage.abs() >= minAnomalyThreshold) {
        final AnomalySeverity severity = _getSeverity(deviationPercentage);
        allAnomalies.add(
          RainfallAnomaly(
            id: _uuid.v4(),
            date: date,
            severity: severity,
            deviationPercentage: deviationPercentage,
            actualRainfall: actualRainfall,
            averageRainfall: averageRainfall,
          ),
        );
      }
    }

    // 4. Filter anomalies based on the selected severity levels.
    final List<RainfallAnomaly> filteredAnomalies =
        allAnomalies
            .where((final a) => filter.severities.contains(a.severity))
            .toList()
          // Sort by date descending
          ..sort((final a, final b) => b.date.compareTo(a.date));

    return AnomalyExplorationData(
      anomalies: filteredAnomalies,
      chartPoints: chartPoints,
    );
  }

  AnomalySeverity _getSeverity(final double deviationPercentage) {
    final double absDeviation = deviationPercentage.abs();
    if (absDeviation >= 400) {
      return AnomalySeverity.critical;
    }
    if (absDeviation >= 200) {
      return AnomalySeverity.high;
    }
    if (absDeviation >= 100) {
      return AnomalySeverity.medium;
    }
    return AnomalySeverity.low;
  }
}
