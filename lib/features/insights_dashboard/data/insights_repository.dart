import "dart:math";

import "package:intl/intl.dart";
import "package:rain_wise/features/insights_dashboard/domain/insights_data.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "insights_repository.g.dart";

abstract class InsightsRepository {
  Future<InsightsData> getInsightsData();
}

@riverpod
InsightsRepository insightsRepository(final InsightsRepositoryRef ref) =>
    MockInsightsRepository();

class MockInsightsRepository implements InsightsRepository {
  @override
  Future<InsightsData> getInsightsData() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    return _getMockInsightsData();
  }

  InsightsData _getMockInsightsData() {
    final now = DateTime.now();
    final random = Random();

    // Generate last 12 months for trend chart
    final List<MonthlyTrendPoint> trendPoints =
        List.generate(12, (final index) {
      final DateTime month = now.subtract(Duration(days: 30 * index));
      return MonthlyTrendPoint(
        month: DateFormat.MMM().format(month),
        rainfall: 50 + random.nextDouble() * 100,
      );
    }).reversed.toList();

    // Generate 12 months for comparison grid
    final List<MonthlyComparisonData> comparisonData =
        List.generate(12, (final index) {
      final month = DateTime(now.year, index + 1);
      return MonthlyComparisonData(
        month: DateFormat.MMMM().format(month),
        mtdTotal: 50 + random.nextInt(100),
        twoYrAvg: 60 + random.nextInt(80),
        fiveYrAvg: 70 + random.nextInt(60),
      );
    });

    return InsightsData(
      keyMetrics: const KeyMetrics(
        totalRainfall: 756.2,
        totalRainfallPrevYearChange: 12.3,
        mtdTotal: 45.7,
        mtdTotalPrevMonthChange: -5.2,
        ytdTotal: 342.8,
        monthlyAvg: 63,
      ),
      monthlyTrends: trendPoints,
      monthlyComparisons: comparisonData,
    );
  }
}
