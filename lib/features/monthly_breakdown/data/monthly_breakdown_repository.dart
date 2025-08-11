import "dart:math";

import "package:rain_wise/features/monthly_breakdown/domain/monthly_breakdown_data.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "monthly_breakdown_repository.g.dart";

abstract class MonthlyBreakdownRepository {
  Future<MonthlyBreakdownData> fetchMonthlyBreakdown(final DateTime month);
}

@riverpod
MonthlyBreakdownRepository monthlyBreakdownRepository(
  final MonthlyBreakdownRepositoryRef ref,
) =>
    MockMonthlyBreakdownRepository();

class MockMonthlyBreakdownRepository implements MonthlyBreakdownRepository {
  @override
  Future<MonthlyBreakdownData> fetchMonthlyBreakdown(
    final DateTime month,
  ) async {
    // Simulate network delay and data fetching/computation
    await Future.delayed(const Duration(seconds: 1));

    final random = Random();
    final int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final double totalRainfall = random.nextDouble() * 200 + 50;

    return MonthlyBreakdownData(
      summaryStats: MonthlySummaryStats(
        totalRainfall: totalRainfall,
        dailyAverage: totalRainfall / daysInMonth,
        highestDay: random.nextDouble() * 20 + 5,
        lowestDay: random.nextDouble() * 2,
      ),
      historicalStats: HistoricalComparisonStats(
        twoYearAvg: totalRainfall * (1 + (random.nextDouble() - 0.4)),
        fiveYearAvg: totalRainfall * (1 + (random.nextDouble() - 0.4)),
        tenYearAvg: totalRainfall * (1 + (random.nextDouble() - 0.4)),
      ),
      dailyChartData: List.generate(
        daysInMonth,
        (final i) =>
            DailyRainfallPoint(day: i + 1, rainfall: random.nextDouble() * 15),
      ),
      dailyBreakdownList: List.generate(
        daysInMonth,
        (final i) => DailyBreakdownItem(
          date: DateTime(month.year, month.month, i + 1),
          rainfall: random.nextDouble() * 15,
          variance: random.nextDouble() * 5 - 2.5,
        ),
      ).reversed.toList(),
    );
  }
}
