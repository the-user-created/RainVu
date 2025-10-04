import "package:collection/collection.dart";
import "package:intl/intl.dart";
import "package:rain_wise/core/data/local/app_database.dart";
import "package:rain_wise/core/data/local/daos/rainfall_entries_dao.dart";
import "package:rain_wise/features/comparative_analysis/domain/comparative_analysis_data.dart";
import "package:rain_wise/shared/domain/seasons.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "comparative_analysis_repository.g.dart";

abstract class ComparativeAnalysisRepository {
  Future<List<int>> getAvailableYears();

  Future<ComparativeAnalysisData> fetchComparativeData(
    final ComparativeFilter filter,
    final Hemisphere hemisphere,
  );
}

@riverpod
ComparativeAnalysisRepository comparativeAnalysisRepository(final Ref ref) {
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
    final Hemisphere hemisphere,
  ) async {
    switch (filter.type) {
      case ComparisonType.annual:
      case ComparisonType.monthly:
        return _fetchAnnualOrMonthlyData(filter);
      case ComparisonType.seasonal:
        return _fetchSeasonalData(filter, hemisphere);
    }
  }

  /// Fetches and processes data for a year-over-year comparison,
  /// broken down by month. This view serves both 'Annual' and 'Monthly' types.
  Future<ComparativeAnalysisData> _fetchAnnualOrMonthlyData(
    final ComparativeFilter filter,
  ) async {
    final List<List<MonthlyTotalForYear>> results = await Future.wait([
      _dao.getMonthlyTotalsForYear(filter.year1),
      _dao.getMonthlyTotalsForYear(filter.year2),
    ]);

    final List<double> monthlyTotals1 = _processMonthlyTotals(results[0]);
    final List<double> monthlyTotals2 = _processMonthlyTotals(results[1]);

    // Build Chart Data
    final List<String> labels = DateFormat.MMMM().dateSymbols.STANDALONEMONTHS
        .map((final m) => m.substring(0, 3))
        .toList();

    final chartData = ComparativeChartData(
      labels: labels,
      series: [
        ComparativeChartSeries(year: filter.year1, data: monthlyTotals1),
        ComparativeChartSeries(year: filter.year2, data: monthlyTotals2),
      ],
    );

    return _buildSummariesAndFinalData(
      chartData: chartData,
      total1: monthlyTotals1.sum,
      total2: monthlyTotals2.sum,
      year1: filter.year1,
      year2: filter.year2,
    );
  }

  /// Fetches and processes data for a year-over-year comparison,
  /// broken down by season, respecting the user's hemisphere.
  Future<ComparativeAnalysisData> _fetchSeasonalData(
    final ComparativeFilter filter,
    final Hemisphere hemisphere,
  ) async {
    final List<Future<double>> futures1 = [];
    final List<Future<double>> futures2 = [];
    final List<String> labels = Season.values
        .map(
          (final season) =>
              season.name[0].toUpperCase() + season.name.substring(1),
        )
        .toList();

    for (final Season season in Season.values) {
      final List<int> months = getMonthsForSeason(season, hemisphere);
      futures1.add(_dao.getSeasonalTotalForYear(filter.year1, months));
      futures2.add(_dao.getSeasonalTotalForYear(filter.year2, months));
    }

    final List<double> seasonalTotals1 = await Future.wait(futures1);
    final List<double> seasonalTotals2 = await Future.wait(futures2);

    final chartData = ComparativeChartData(
      labels: labels,
      series: [
        ComparativeChartSeries(year: filter.year1, data: seasonalTotals1),
        ComparativeChartSeries(year: filter.year2, data: seasonalTotals2),
      ],
    );

    return _buildSummariesAndFinalData(
      chartData: chartData,
      total1: seasonalTotals1.sum,
      total2: seasonalTotals2.sum,
      year1: filter.year1,
      year2: filter.year2,
    );
  }

  /// Common logic to build summaries and the final data object.
  ComparativeAnalysisData _buildSummariesAndFinalData({
    required final ComparativeChartData chartData,
    required final double total1,
    required final double total2,
    required final int year1,
    required final int year2,
  }) {
    final double change1vs2 = _calculatePercentageChange(total1, total2);
    final double change2vs1 = _calculatePercentageChange(total2, total1);

    final List<YearlySummary> summaries = [
      YearlySummary(
        year: year1,
        totalRainfall: total1,
        percentageChange: change1vs2,
      ),
      YearlySummary(
        year: year2,
        totalRainfall: total2,
        percentageChange: change2vs1,
      ),
    ]..sort((final a, final b) => b.year.compareTo(a.year));

    return ComparativeAnalysisData(summaries: summaries, chartData: chartData);
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
      return newValue > 0 ? double.infinity : 0.0;
    }
    return ((newValue - baseValue) / baseValue) * 100;
  }
}
