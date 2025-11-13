import "package:collection/collection.dart";
import "package:intl/intl.dart";
import "package:rainvu/core/application/filter_provider.dart";
import "package:rainvu/core/data/local/app_database.dart";
import "package:rainvu/core/data/local/daos/rainfall_entries_dao.dart";
import "package:rainvu/features/insights_dashboard/domain/insights_data.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "insights_repository.g.dart";

abstract class InsightsRepository {
  Future<InsightsData> getInsightsData({required String gaugeId});
}

@riverpod
InsightsRepository insightsRepository(final Ref ref) {
  final AppDatabase db = ref.watch(appDatabaseProvider);
  return DriftInsightsRepository(db.rainfallEntriesDao);
}

class DriftInsightsRepository implements InsightsRepository {
  DriftInsightsRepository(this._dao);

  final RainfallEntriesDao _dao;
  final _now = DateTime.now();

  @override
  Future<InsightsData> getInsightsData({required String gaugeId}) async {
    final String? filterGaugeId = gaugeId == allGaugesFilterId ? null : gaugeId;

    final List<Object> results = await Future.wait([
      _getMtdData(),
      _getYtdData(),
      _getLast12MonthsData(),
      _getAllTimeData(),
      _getMonthlyAverages(gaugeId: filterGaugeId),
    ]);

    return InsightsData(
      mtdData: results[0] as MetricData,
      ytdData: results[1] as MetricData,
      last12MonthsData: results[2] as MetricData,
      allTimeData: results[3] as MetricData,
      monthlyAverages: results[4] as List<MonthlyAveragesData>,
    );
  }

  // --- Metric Data Fetchers ---

  Future<MetricData> _getMtdData() async {
    final startOfThisMonth = DateTime(_now.year, _now.month);
    final startOfLastMonth = DateTime(_now.year, _now.month - 1);
    final endOfLastMonthComparable = DateTime(
      _now.year,
      _now.month - 1,
      _now.day,
    );

    final double currentMtdTotal = await _dao.getTotalAmountBetween(
      startOfThisMonth,
      _now,
    );
    final double prevMtdTotal = await _dao.getTotalAmountBetween(
      startOfLastMonth,
      endOfLastMonthComparable,
    );
    final List<DailyTotal> dailyTotals = await _dao.getDailyTotalsForMonth(
      _now.year,
      _now.month,
    );

    final List<ChartPoint> chartPoints = List.generate(
      DateTime(_now.year, _now.month + 1, 0).day,
      (final index) {
        final int day = index + 1;
        final double total =
            dailyTotals.firstWhereOrNull((final d) => d.day == day)?.total ??
            0.0;
        return ChartPoint(
          label: day.toString(),
          value: total,
          date: DateTime(_now.year, _now.month, day),
        );
      },
    );

    return MetricData(
      primaryValue: currentMtdTotal,
      changePercentage: _calculatePercentChange(prevMtdTotal, currentMtdTotal),
      changeLabel: "dashboardComparisonVsPrevious",
      chartPoints: chartPoints,
    );
  }

  Future<MetricData> _getYtdData() async {
    final startOfThisYear = DateTime(_now.year);
    final startOfLastYear = DateTime(_now.year - 1);
    final endOfLastYearComparable = DateTime(
      _now.year - 1,
      _now.month,
      _now.day,
    );

    final double currentYtdTotal = await _dao.getTotalAmountBetween(
      startOfThisYear,
      _now,
    );
    final double prevYtdTotal = await _dao.getTotalAmountBetween(
      startOfLastYear,
      endOfLastYearComparable,
    );
    final List<MonthlyTotalForYear> monthlyTotals = await _dao
        .getMonthlyTotalsForYear(_now.year);

    final List<ChartPoint> chartPoints = List.generate(12, (final index) {
      final int month = index + 1;
      final double total =
          monthlyTotals
              .firstWhereOrNull((final t) => t.month == month)
              ?.total ??
          0.0;
      return ChartPoint(
        label: DateFormat.MMM().format(DateTime(0, month)),
        value: total,
        date: DateTime(_now.year, month),
      );
    });

    return MetricData(
      primaryValue: currentYtdTotal,
      changePercentage: _calculatePercentChange(prevYtdTotal, currentYtdTotal),
      changeLabel: "dashboardComparisonVsPrevious",
      chartPoints: chartPoints,
    );
  }

  Future<MetricData> _getLast12MonthsData() async {
    final twelveMonthsAgo = DateTime(_now.year, _now.month - 11);
    final List<MonthlyTotal> monthlyTotals = await _dao.getMonthlyTotals(
      start: twelveMonthsAgo,
      end: _now,
    );
    final List<MonthlyTotal> allMonthlyTotals = await _dao
        .getAllMonthlyTotals();

    final double currentPeriodTotal = monthlyTotals
        .map((final e) => e.total)
        .sum;
    final double historicalAverage = allMonthlyTotals.isEmpty
        ? 0.0
        : allMonthlyTotals.map((final e) => e.total).average;

    final List<ChartPoint> chartPoints = List.generate(12, (final index) {
      final date = DateTime(_now.year, _now.month - (11 - index));
      final double total =
          monthlyTotals
              .firstWhereOrNull(
                (final t) => t.year == date.year && t.month == date.month,
              )
              ?.total ??
          0.0;
      return ChartPoint(
        label: DateFormat.MMM().format(date),
        value: total,
        date: date,
      );
    });

    return MetricData(
      primaryValue: currentPeriodTotal,
      changePercentage: _calculatePercentChange(
        historicalAverage * 12,
        currentPeriodTotal,
      ),
      changeLabel: "dashboardComparisonVsAverage",
      chartPoints: chartPoints,
    );
  }

  Future<MetricData> _getAllTimeData() async {
    final List<int> allYears = (await _dao.getAvailableYears())..sort();
    if (allYears.isEmpty) {
      return const MetricData(
        primaryValue: 0,
        changePercentage: 0,
        changeLabel: "",
        chartPoints: [],
      );
    }

    final Iterable<Future<double>> yearlyTotalsFutures = allYears.map(
      _dao.getYearlyTotal,
    );
    final List<double> yearlyTotalsList = await Future.wait(
      yearlyTotalsFutures,
    );

    final double totalRainfall = yearlyTotalsList.sum;
    final double yearlyAverage = totalRainfall / allYears.length;

    final List<ChartPoint> chartPoints = allYears
        .mapIndexed(
          (final index, final year) => ChartPoint(
            label: year.toString(),
            value: yearlyTotalsList[index],
          ),
        )
        .toList();

    return MetricData(
      primaryValue: totalRainfall,
      changePercentage: 0,
      changeLabel: "yearly average: ${yearlyAverage.toStringAsFixed(1)}",
      chartPoints: chartPoints,
    );
  }

  // --- Other Data Fetchers ---

  Future<List<MonthlyAveragesData>> _getMonthlyAverages({
    final String? gaugeId,
  }) async {
    final int currentYear = _now.year;
    final List<int> previous20Years = List.generate(
      20,
      (final index) => currentYear - 1 - index,
    );
    final futures = <Future<MonthlyAveragesData>>[];

    for (int month = 1; month <= 12; month++) {
      futures.add(
        _getComparisonForMonth(
          month,
          currentYear,
          previous20Years,
          gaugeId: gaugeId,
        ),
      );
    }
    return Future.wait(futures);
  }

  Future<MonthlyAveragesData> _getComparisonForMonth(
    final int month,
    final int currentYear,
    final List<int> previousYears, {
    final String? gaugeId,
  }) async {
    final startOfMonth = DateTime(currentYear, month);
    final DateTime endOfMonth = DateTime(
      currentYear,
      month + 1,
    ).subtract(const Duration(microseconds: 1));
    final Future<double> currentMonthTotalFuture = _dao.getTotalAmountBetween(
      startOfMonth,
      endOfMonth,
      gaugeId: gaugeId,
    );
    final Future<List<YearlyTotal>> previousYearsTotalsFuture = _dao
        .getTotalsForMonthAcrossYears(
          month: month,
          years: previousYears,
          gaugeId: gaugeId,
        );

    final List<Object> results = await Future.wait([
      currentMonthTotalFuture,
      previousYearsTotalsFuture,
    ]);
    final currentMonthTotal = results[0] as double;
    final previousYearsTotals = results[1] as List<YearlyTotal>;

    // For a 2-year average, require data from at least 2 years.
    final List<YearlyTotal> twoYrTotals = previousYearsTotals
        .where((final t) => t.year >= currentYear - 2)
        .toList();
    final double? twoYrAvg = twoYrTotals.length < 2
        ? null
        : twoYrTotals.map((final t) => t.total).sum / twoYrTotals.length;

    // For a 5-year average, require data from at least 4 years (80%).
    final List<YearlyTotal> fiveYrTotals = previousYearsTotals
        .where((final t) => t.year >= currentYear - 5)
        .toList();
    final double? fiveYrAvg = fiveYrTotals.length < 4
        ? null
        : fiveYrTotals.map((final t) => t.total).sum / fiveYrTotals.length;

    // For a 10-year average, require data from at least 8 years (80%).
    final List<YearlyTotal> tenYrTotals = previousYearsTotals
        .where((final t) => t.year >= currentYear - 10)
        .toList();
    final double? tenYrAvg = tenYrTotals.length < 8
        ? null
        : tenYrTotals.map((final t) => t.total).sum / tenYrTotals.length;

    // For a 15-year average, require data from at least 12 years (80%).
    final List<YearlyTotal> fifteenYrTotals = previousYearsTotals
        .where((final t) => t.year >= currentYear - 15)
        .toList();
    final double? fifteenYrAvg = fifteenYrTotals.length < 12
        ? null
        : fifteenYrTotals.map((final t) => t.total).sum /
              fifteenYrTotals.length;

    // For a 20-year average, require data from at least 16 years (80%).
    final List<YearlyTotal> twentyYrTotals = previousYearsTotals
        .where((final t) => t.year >= currentYear - 20)
        .toList();
    final double? twentyYrAvg = twentyYrTotals.length < 16
        ? null
        : twentyYrTotals.map((final t) => t.total).sum / twentyYrTotals.length;

    return MonthlyAveragesData(
      month: DateFormat.MMMM().format(DateTime(0, month)),
      mtdTotal: currentMonthTotal,
      twoYrAvg: twoYrAvg,
      fiveYrAvg: fiveYrAvg,
      tenYrAvg: tenYrAvg,
      fifteenYrAvg: fifteenYrAvg,
      twentyYrAvg: twentyYrAvg,
    );
  }

  // --- Helpers ---

  double _calculatePercentChange(final double previous, final double current) {
    if (previous == 0) {
      return current > 0 ? 100.0 : 0.0;
    }
    return (current - previous) / previous * 100;
  }
}
