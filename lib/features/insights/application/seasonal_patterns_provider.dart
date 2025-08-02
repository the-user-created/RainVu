import "dart:math";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:rain_wise/features/insights/domain/seasonal_patterns_data.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "seasonal_patterns_provider.g.dart";

part "seasonal_patterns_provider.freezed.dart";

@freezed
abstract class SeasonalFilter with _$SeasonalFilter {
  const factory SeasonalFilter({
    required final int year,
    @Default(Season.spring) final Season season,
  }) = _SeasonalFilter;
}

@riverpod
class SeasonalPatternsFilterNotifier extends _$SeasonalPatternsFilterNotifier {
  @override
  SeasonalFilter build() => SeasonalFilter(year: DateTime.now().year);

  void setFilter(final Season season, final int year) {
    state = SeasonalFilter(season: season, year: year);
  }
}

/// Fetches seasonal patterns data based on the current filter.
///
/// In a real application, this would call a repository to get data from a
/// backend or local database. Here, it generates mock data.
@riverpod
Future<SeasonalPatternsData> seasonalPatternsData(
  final SeasonalPatternsDataRef ref,
) async {
  final SeasonalFilter filter =
      ref.watch(seasonalPatternsFilterNotifierProvider);

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
