import "package:intl/intl.dart";
import "package:rainvu/core/data/local/app_database.dart";
import "package:rainvu/core/data/local/daos/rainfall_entries_dao.dart";
import "package:rainvu/features/yearly_comparison/domain/yearly_comparison_data.dart";
import "package:rainvu/shared/domain/seasons.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "yearly_comparison_repository.g.dart";

abstract class YearlyComparisonRepository {
  Future<List<int>> getAvailableYears();

  Future<List<YearlySummary>> fetchComparativeSummaries(
    final int year1,
    final int year2,
  );

  Future<ComparativeChartData> fetchComparativeChartData(
    final ComparativeFilter filter,
    final Hemisphere hemisphere,
  );
}

@riverpod
YearlyComparisonRepository yearlyComparisonRepository(final Ref ref) {
  final AppDatabase db = ref.watch(appDatabaseProvider);
  return DriftYearlyComparisonRepository(db.rainfallEntriesDao);
}

class DriftYearlyComparisonRepository implements YearlyComparisonRepository {
  DriftYearlyComparisonRepository(this._dao);

  final RainfallEntriesDao _dao;

  @override
  Future<List<int>> getAvailableYears() async {
    final List<int> years = await _dao.getAvailableYears();
    // Sort descending to show most recent years first in the dropdown.
    years.sort((final a, final b) => b.compareTo(a));
    return years;
  }

  @override
  Future<List<YearlySummary>> fetchComparativeSummaries(
    final int year1,
    final int year2,
  ) async {
    final List<double> totals = await Future.wait([
      _dao.getYearlyTotal(year1),
      _dao.getYearlyTotal(year2),
    ]);
    final double total1 = totals[0];
    final double total2 = totals[1];

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

    return summaries;
  }

  @override
  Future<ComparativeChartData> fetchComparativeChartData(
    final ComparativeFilter filter,
    final Hemisphere hemisphere,
  ) async {
    switch (filter.type) {
      case ComparisonType.annual:
        return _fetchAnnualChartData(filter);
      case ComparisonType.monthly:
        return _fetchMonthlyChartData(filter);
      case ComparisonType.seasonal:
        return _fetchSeasonalChartData(filter, hemisphere);
    }
  }

  /// Fetches chart data for a year-over-year comparison,
  /// showing only the annual total.
  Future<ComparativeChartData> _fetchAnnualChartData(
    final ComparativeFilter filter,
  ) async {
    final List<double> totals = await Future.wait([
      _dao.getYearlyTotal(filter.year1),
      _dao.getYearlyTotal(filter.year2),
    ]);
    final double total1 = totals[0];
    final double total2 = totals[1];

    return ComparativeChartData(
      labels: const [""],
      series: [
        ComparativeChartSeries(year: filter.year1, data: [total1]),
        ComparativeChartSeries(year: filter.year2, data: [total2]),
      ],
    );
  }

  /// Fetches chart data for a year-over-year comparison,
  /// broken down by month.
  Future<ComparativeChartData> _fetchMonthlyChartData(
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

    return ComparativeChartData(
      labels: labels,
      series: [
        ComparativeChartSeries(year: filter.year1, data: monthlyTotals1),
        ComparativeChartSeries(year: filter.year2, data: monthlyTotals2),
      ],
    );
  }

  /// Fetches chart data for a year-over-year comparison,
  /// broken down by season, respecting the user's hemisphere.
  Future<ComparativeChartData> _fetchSeasonalChartData(
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

    return ComparativeChartData(
      labels: labels,
      series: [
        ComparativeChartSeries(year: filter.year1, data: seasonalTotals1),
        ComparativeChartSeries(year: filter.year2, data: seasonalTotals2),
      ],
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
      return newValue > 0 ? double.infinity : 0.0;
    }
    return ((newValue - baseValue) / baseValue) * 100;
  }
}
