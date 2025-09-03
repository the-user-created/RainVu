import "package:collection/collection.dart";
import "package:intl/intl.dart";
import "package:rain_wise/core/data/local/app_database.dart";
import "package:rain_wise/core/data/local/daos/rainfall_entries_dao.dart";
import "package:rain_wise/features/comparative_analysis/domain/comparative_analysis_data.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "comparative_analysis_repository.g.dart";

abstract class ComparativeAnalysisRepository {
  Future<List<int>> getAvailableYears();

  Future<ComparativeAnalysisData> fetchComparativeData(
    final ComparativeFilter filter,
  );
}

@riverpod
ComparativeAnalysisRepository comparativeAnalysisRepository(
  final ComparativeAnalysisRepositoryRef ref,
) {
  final AppDatabase db = ref.watch(appDatabaseProvider);
  return DriftComparativeAnalysisRepository(db.rainfallEntriesDao);
}

class DriftComparativeAnalysisRepository
    implements ComparativeAnalysisRepository {
  DriftComparativeAnalysisRepository(this._dao);

  final RainfallEntriesDao _dao;

  @override
  Future<List<int>> getAvailableYears() async {
    final List<int> years = await _dao.getAvailableYears();
    // Sort descending to show most recent years first in the dropdown.
    years.sort((final a, final b) => b.compareTo(a));
    return years;
  }

  @override
  Future<ComparativeAnalysisData> fetchComparativeData(
    final ComparativeFilter filter,
  ) async {
    // Parallel fetch for both years is more efficient.
    final List<List<MonthlyTotalForYear>> results = await Future.wait([
      _dao.getMonthlyTotalsForYear(filter.year1),
      _dao.getMonthlyTotalsForYear(filter.year2),
    ]);

    final List<double> monthlyTotals1 = _processMonthlyTotals(results[0]);
    final List<double> monthlyTotals2 = _processMonthlyTotals(results[1]);

    // Build Chart Data
    final List<String> labels = DateFormat.MMMM()
        .dateSymbols
        .STANDALONEMONTHS
        .map((final m) => m.substring(0, 3))
        .toList();

    final chartData = ComparativeChartData(
      labels: labels,
      series: [
        ComparativeChartSeries(year: filter.year1, data: monthlyTotals1),
        ComparativeChartSeries(year: filter.year2, data: monthlyTotals2),
      ],
    );

    // Build Summaries
    final double total1 = monthlyTotals1.sum;
    final double total2 = monthlyTotals2.sum;

    final double change1vs2 = _calculatePercentageChange(total1, total2);
    final double change2vs1 = _calculatePercentageChange(total2, total1);

    final summaries = [
      YearlySummary(
        year: filter.year1,
        totalRainfall: total1,
        percentageChange: change1vs2,
      ),
      YearlySummary(
        year: filter.year2,
        totalRainfall: total2,
        percentageChange: change2vs1,
      ),
    ]
      // Sort summaries by year descending for consistent display.
      ..sort((final a, final b) => b.year.compareTo(a.year));

    return ComparativeAnalysisData(
      summaries: summaries,
      chartData: chartData,
    );
  }

  /// Processes the raw query result from the DAO into a 12-element list
  /// representing monthly totals.
  List<double> _processMonthlyTotals(final List<MonthlyTotalForYear> rawData) {
    // Use a map for efficient lookup (month -> total).
    final Map<int, double> monthlyMap = {
      for (final row in rawData) row.month: row.total,
    };

    // Create a list for all 12 months, filling with data from the map or 0.0.
    return List.generate(12, (final index) => monthlyMap[index + 1] ?? 0.0);
  }

  /// Calculates the percentage change from a base value to a new value.
  double _calculatePercentageChange(
    final double newValue,
    final double baseValue,
  ) {
    if (baseValue == 0) {
      // Avoid division by zero. If the base is 0, any positive new value
      // is an infinite increase. We represent this with double.infinity,
      // and the UI can decide how to display it. If the new value is also 0,
      // there is no change.
      return newValue > 0 ? double.infinity : 0.0;
    }
    return ((newValue - baseValue) / baseValue) * 100;
  }
}
