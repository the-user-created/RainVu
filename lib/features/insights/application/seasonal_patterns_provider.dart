import "package:freezed_annotation/freezed_annotation.dart";
import "package:rain_wise/features/insights/data/seasonal_patterns_repository.dart";
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

  final SeasonalPatternsRepository repository =
      ref.watch(seasonalPatternsRepositoryProvider);
  return repository.fetchSeasonalPatterns(filter);
}
