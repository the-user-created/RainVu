import "package:collection/collection.dart";
import "package:intl/intl.dart";
import "package:rain_wise/core/data/local/app_database.dart";
import "package:rain_wise/core/data/local/daos/rainfall_entries_dao.dart";
import "package:rain_wise/features/insights_dashboard/domain/insights_data.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "insights_repository.g.dart";

abstract class InsightsRepository {
  Future<InsightsData> getInsightsData();
}

@riverpod
InsightsRepository insightsRepository(final Ref ref) {
  final AppDatabase db = ref.watch(appDatabaseProvider);
  return DriftInsightsRepository(db.rainfallEntriesDao);
}

class DriftInsightsRepository implements InsightsRepository {
  DriftInsightsRepository(this._dao);

  final RainfallEntriesDao _dao;

  @override
  Future<InsightsData> getInsightsData() async {
    final now = DateTime.now();

    final List<Object> futures = await Future.wait([
      _calculateKeyMetrics(now),
      _getMonthlyComparisons(now),
    ]);

    return InsightsData(
      keyMetrics: futures[0] as KeyMetrics,
      monthlyComparisons: futures[1] as List<MonthlyComparisonData>,
    );
  }

  Future<KeyMetrics> _calculateKeyMetrics(final DateTime now) async {
    final startOfThisYear = DateTime(now.year);
    final startOfThisMonth = DateTime(now.year, now.month);
    final oneYearAgo = DateTime(
      now.year - 1,
      now.month,
      now.day,
      now.hour,
      now.minute,
      now.second,
    );

    final startOfLastMonth = DateTime(now.year, now.month - 1);
    final endOfLastMonthMTD = DateTime(now.year, now.month - 1, now.day);
    final startOfLastYear = DateTime(now.year - 1);

    final Future<double> totalRainfallFuture = _dao.getTotalRainfall();
    final Future<double> ytdTotalFuture = _dao.getTotalAmountBetween(
      startOfThisYear,
      now,
    );
    final Future<double> mtdTotalFuture = _dao.getTotalAmountBetween(
      startOfThisMonth,
      now,
    );
    final Future<double> totalRainfallLastYearFuture = _dao
        .getTotalAmountBetween(DateTime(1900), oneYearAgo);
    final Future<double> mtdTotalLastMonthFuture = _dao.getTotalAmountBetween(
      startOfLastMonth,
      endOfLastMonthMTD,
    );
    final Future<List<MonthlyTotal>> allMonthlyTotalsFuture = _dao
        .getAllMonthlyTotals();
    final Future<double> ytdTotalLastYearFuture = _dao.getTotalAmountBetween(
      startOfLastYear,
      oneYearAgo,
    );

    final List<Object> results = await Future.wait([
      totalRainfallFuture,
      ytdTotalFuture,
      mtdTotalFuture,
      totalRainfallLastYearFuture,
      mtdTotalLastMonthFuture,
      allMonthlyTotalsFuture,
      ytdTotalLastYearFuture,
    ]);

    final totalRainfall = results[0] as double;
    final ytdTotal = results[1] as double;
    final mtdTotal = results[2] as double;
    final totalRainfallLastYear = results[3] as double;
    final mtdTotalLastMonth = results[4] as double;
    final allMonthlyTotals = results[5] as List<MonthlyTotal>;
    final ytdTotalLastYear = results[6] as double;

    final double totalRainfallChange = _calculatePercentChange(
      totalRainfallLastYear,
      totalRainfall,
    );
    final double mtdChange = _calculatePercentChange(
      mtdTotalLastMonth,
      mtdTotal,
    );
    final double ytdChange = _calculatePercentChange(
      ytdTotalLastYear,
      ytdTotal,
    );

    final double monthlyAvg = allMonthlyTotals.isEmpty
        ? 0.0
        : allMonthlyTotals.map((final e) => e.total).average;

    final double monthlyAvgChange = _calculatePercentChange(
      monthlyAvg,
      mtdTotal,
    );

    return KeyMetrics(
      totalRainfall: totalRainfall,
      ytdTotal: ytdTotal,
      mtdTotal: mtdTotal,
      totalRainfallPrevYearChange: totalRainfallChange,
      mtdTotalPrevMonthChange: mtdChange,
      ytdTotalPrevYearChange: ytdChange,
      monthlyAvg: monthlyAvg,
      monthlyAvgChangeVsCurrentMonth: monthlyAvgChange,
    );
  }

  double _calculatePercentChange(final double previous, final double current) {
    if (previous == 0) {
      // If previous is 0, any positive current value is an infinite increase.
      // Represent this as 100% for simplicity in UI.
      return current > 0 ? 100.0 : 0.0;
    }
    return (current - previous) / previous * 100;
  }

  Future<List<MonthlyComparisonData>> _getMonthlyComparisons(
    final DateTime now,
  ) async {
    final int currentYear = now.year;
    final List<int> previous5Years = List.generate(
      5,
      (final index) => currentYear - 1 - index,
    );

    final List<Future<MonthlyComparisonData>> futures = [];

    for (int month = 1; month <= 12; month++) {
      futures.add(_getComparisonForMonth(month, currentYear, previous5Years));
    }

    return Future.wait(futures);
  }

  Future<MonthlyComparisonData> _getComparisonForMonth(
    final int month,
    final int currentYear,
    final List<int> previousYears,
  ) async {
    final startOfMonth = DateTime(currentYear, month);
    final DateTime endOfMonth = DateTime(
      currentYear,
      month + 1,
    ).subtract(const Duration(microseconds: 1));
    final Future<double> currentMonthTotalFuture = _dao.getTotalAmountBetween(
      startOfMonth,
      endOfMonth,
    );

    final Future<List<YearlyTotal>> previousYearsTotalsFuture = _dao
        .getTotalsForMonthAcrossYears(month: month, years: previousYears);

    final List<Object> results = await Future.wait([
      currentMonthTotalFuture,
      previousYearsTotalsFuture,
    ]);

    final currentMonthTotal = results[0] as double;
    final previousYearsTotals = results[1] as List<YearlyTotal>;

    final double twoYrSum = previousYearsTotals
        .where((final t) => t.year >= currentYear - 2)
        .map((final t) => t.total)
        .fold(0, (final a, final b) => a + b);

    final double fiveYrSum = previousYearsTotals
        .map((final t) => t.total)
        .fold(0, (final a, final b) => a + b);

    return MonthlyComparisonData(
      month: DateFormat.MMMM().format(DateTime(0, month)),
      mtdTotal: currentMonthTotal,
      twoYrAvg: twoYrSum > 0 ? twoYrSum / 2 : 0,
      fiveYrAvg: fiveYrSum > 0 ? fiveYrSum / 5 : 0,
    );
  }
}
