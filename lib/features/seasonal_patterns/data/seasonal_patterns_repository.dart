import "dart:math";

import "package:rain_wise/features/seasonal_patterns/application/seasonal_patterns_provider.dart";
import "package:rain_wise/features/seasonal_patterns/domain/seasonal_patterns_data.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "seasonal_patterns_repository.g.dart";

abstract class SeasonalPatternsRepository {
  Future<SeasonalPatternsData> fetchSeasonalPatterns(
    final SeasonalFilter filter,
  );
}

@riverpod
SeasonalPatternsRepository seasonalPatternsRepository(
  final SeasonalPatternsRepositoryRef ref,
) =>
    MockSeasonalPatternsRepository();

class MockSeasonalPatternsRepository implements SeasonalPatternsRepository {
  @override
  Future<SeasonalPatternsData> fetchSeasonalPatterns(
    final SeasonalFilter filter,
  ) async {
    // Simulate network delay and data computation
    await Future.delayed(const Duration(milliseconds: 600));
    final random = Random();

    // Generate mock data for a 3-month season
    final List<SeasonalTrendPoint> trendData = List.generate(90, (final i) {
      final baseDate = DateTime(filter.year, filter.season.index * 3 + 1);
      return SeasonalTrendPoint(
        date: baseDate.add(Duration(days: i)),
        // Make data vary by season for more realistic mock data
        rainfall: random.nextDouble() * 5 + (filter.season.index * 1.5),
      );
    });

    final List<double> rainfallValues =
        trendData.map((final e) => e.rainfall).toList();
    if (rainfallValues.isEmpty) {
      return const SeasonalPatternsData(
        summary: SeasonalSummary(
          averageRainfall: 0,
          trendVsHistory: 0,
          highestRecorded: 0,
          lowestRecorded: 0,
        ),
        trendData: [],
      );
    }

    return SeasonalPatternsData(
      summary: SeasonalSummary(
        averageRainfall: rainfallValues.reduce((final a, final b) => a + b) /
            rainfallValues.length,
        trendVsHistory: (random.nextDouble() * 40) - 20, // -20% to +20%
        highestRecorded: rainfallValues.reduce(max),
        lowestRecorded: rainfallValues.reduce(min),
      ),
      trendData: trendData,
    );
  }
}
