import "dart:math";

import "package:collection/collection.dart";
import "package:rain_wise/core/data/local/app_database.dart";
import "package:rain_wise/core/data/local/daos/rainfall_entries_dao.dart";
import "package:rain_wise/features/monthly_breakdown/domain/monthly_breakdown_data.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "monthly_breakdown_repository.g.dart";

// TODO: Doesn't update in real-time when entries change via the rainfall_entry subscreen

abstract class MonthlyBreakdownRepository {
  Future<MonthlyBreakdownData> fetchMonthlyBreakdown(final DateTime month);
}

@riverpod
MonthlyBreakdownRepository monthlyBreakdownRepository(
  final Ref ref,
) {
  final AppDatabase db = ref.watch(appDatabaseProvider);
  return DriftMonthlyBreakdownRepository(db.rainfallEntriesDao);
}

class DriftMonthlyBreakdownRepository implements MonthlyBreakdownRepository {
  DriftMonthlyBreakdownRepository(this._dao);

  final RainfallEntriesDao _dao;

  @override
  Future<MonthlyBreakdownData> fetchMonthlyBreakdown(
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
      _dao.getDailyHistoricalDataForMonth(monthValue, year),
    ]);

    final dailyTotals = results[0] as List<DailyTotal>;
    final historicalTotals = results[1] as List<YearlyTotal>;
    final historicalDailyData = results[2] as List<DailyHistoricalData>;

    // Process the fetched data
    final Map<int, double> dailyTotalsMap = {
      for (final v in dailyTotals) v.day: v.total,
    };
    final Map<int, double> historicalDailyAverages = {
      for (final v in historicalDailyData) v.day: v.total / v.yearCount,
    };

    final MonthlySummaryStats summaryStats =
        _calculateSummaryStats(dailyTotals, daysInMonth);
    final HistoricalComparisonStats historicalStats =
        _calculateHistoricalStats(historicalTotals, year);

    final List<DailyRainfallPoint> chartData = [];
    final List<DailyBreakdownItem> breakdownList = [];

    for (int day = 1; day <= daysInMonth; day++) {
      final double rainfall = dailyTotalsMap[day] ?? 0.0;
      chartData.add(DailyRainfallPoint(day: day, rainfall: rainfall));

      // Only add an entry to the breakdown list if there was rainfall that day
      if (rainfall > 0.0) {
        final double avgRainfall = historicalDailyAverages[day] ?? 0.0;
        breakdownList.add(
          DailyBreakdownItem(
            date: DateTime(year, monthValue, day),
            rainfall: rainfall,
            variance: rainfall - avgRainfall,
          ),
        );
      }
    }

    // Sort the list to show the most recent days first
    breakdownList.sort((final a, final b) => b.date.compareTo(a.date));

    return MonthlyBreakdownData(
      summaryStats: summaryStats,
      historicalStats: historicalStats,
      dailyChartData: chartData,
      dailyBreakdownList: breakdownList,
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
    final double dailyAverage =
        daysInMonth > 0 ? totalRainfall / daysInMonth : 0.0;
    final double highestDay = dailyTotals.map((final e) => e.total).reduce(max);
    final Iterable<DailyTotal> rainyDays =
        dailyTotals.where((final e) => e.total > 0);
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

  HistoricalComparisonStats _calculateHistoricalStats(
    final List<YearlyTotal> historicalTotals,
    final int currentYear,
  ) {
    final Map<int, double> historicalMap = {
      for (final v in historicalTotals) v.year: v.total,
    };

    final double twoYearSum = [currentYear - 1, currentYear - 2]
        .map((final year) => historicalMap[year] ?? 0.0)
        .sum;
    final double fiveYearSum =
        List.generate(5, (final i) => currentYear - 1 - i)
            .map((final year) => historicalMap[year] ?? 0.0)
            .sum;
    final double tenYearSum =
        List.generate(10, (final i) => currentYear - 1 - i)
            .map((final year) => historicalMap[year] ?? 0.0)
            .sum;

    return HistoricalComparisonStats(
      twoYearAvg: twoYearSum / 2,
      fiveYearAvg: fiveYearSum / 5,
      tenYearAvg: tenYearSum / 10,
    );
  }
}
