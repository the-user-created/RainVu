import "dart:math";

import "package:collection/collection.dart";
import "package:rainly/core/data/local/app_database.dart";
import "package:rainly/core/data/local/daos/rainfall_entries_dao.dart";
import "package:rainly/features/daily_breakdown/domain/daily_breakdown_data.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "daily_breakdown_repository.g.dart";

abstract class DailyBreakdownRepository {
  Future<DailyBreakdownData> fetchDailyBreakdown(final DateTime month);
}

@riverpod
DailyBreakdownRepository dailyBreakdownRepository(final Ref ref) {
  final AppDatabase db = ref.watch(appDatabaseProvider);
  return DriftDailyBreakdownRepository(db.rainfallEntriesDao);
}

class DriftDailyBreakdownRepository implements DailyBreakdownRepository {
  DriftDailyBreakdownRepository(this._dao);

  final RainfallEntriesDao _dao;

  @override
  Future<DailyBreakdownData> fetchDailyBreakdown(
    final DateTime month,
  ) async {
    final int year = month.year;
    final int monthValue = month.month;
    final int daysInMonth = DateTime(year, monthValue + 1, 0).day;

    // Fetch all necessary data from the database in parallel for efficiency
    final List<List<Object>> results = await Future.wait([
      _dao.getDailyTotalsForMonth(year, monthValue),
      _dao.getTotalsForMonthAcrossYears(
        month: monthValue,
        years: List.generate(10, (final index) => year - 1 - index),
      ),
    ]);

    final dailyTotals = results[0] as List<DailyTotal>;
    final historicalTotals = results[1] as List<YearlyTotal>;

    // Process the fetched data
    final Map<int, double> dailyTotalsMap = {
      for (final v in dailyTotals) v.day: v.total,
    };

    final MonthlySummaryStats summaryStats = _calculateSummaryStats(
      dailyTotals,
      daysInMonth,
    );
    final PastAveragesStats historicalStats = _calculateHistoricalStats(
      historicalTotals,
      year,
    );

    final List<DailyRainfallPoint> chartData = [];

    for (int day = 1; day <= daysInMonth; day++) {
      final double rainfall = dailyTotalsMap[day] ?? 0.0;
      chartData.add(DailyRainfallPoint(day: day, rainfall: rainfall));
    }

    return DailyBreakdownData(
      summaryStats: summaryStats,
      historicalStats: historicalStats,
      dailyChartData: chartData,
    );
  }

  MonthlySummaryStats _calculateSummaryStats(
    final List<DailyTotal> dailyTotals,
    final int daysInMonth,
  ) {
    if (dailyTotals.isEmpty) {
      return const MonthlySummaryStats(
        totalRainfall: 0,
        dailyAverage: 0,
        highestDay: 0,
        lowestDay: 0,
      );
    }

    final double totalRainfall = dailyTotals.map((final e) => e.total).sum;
    final double dailyAverage = daysInMonth > 0
        ? totalRainfall / daysInMonth
        : 0.0;
    final double highestDay = dailyTotals.map((final e) => e.total).reduce(max);
    final Iterable<DailyTotal> rainyDays = dailyTotals.where(
      (final e) => e.total > 0,
    );
    final double lowestDay = rainyDays.isEmpty
        ? 0.0
        : rainyDays.map((final e) => e.total).reduce(min);

    return MonthlySummaryStats(
      totalRainfall: totalRainfall,
      dailyAverage: dailyAverage,
      highestDay: highestDay,
      lowestDay: lowestDay,
    );
  }

  PastAveragesStats _calculateHistoricalStats(
    final List<YearlyTotal> historicalTotals,
    final int currentYear,
  ) {
    final Map<int, double> historicalMap = {
      for (final v in historicalTotals) v.year: v.total,
    };

    final double twoYearSum = [
      currentYear - 1,
      currentYear - 2,
    ].map((final year) => historicalMap[year] ?? 0.0).sum;
    final double fiveYearSum = List.generate(
      5,
      (final i) => currentYear - 1 - i,
    ).map((final year) => historicalMap[year] ?? 0.0).sum;
    final double tenYearSum = List.generate(
      10,
      (final i) => currentYear - 1 - i,
    ).map((final year) => historicalMap[year] ?? 0.0).sum;

    return PastAveragesStats(
      twoYearAvg: twoYearSum / 2,
      fiveYearAvg: fiveYearSum / 5,
      tenYearAvg: tenYearSum / 10,
    );
  }
}
