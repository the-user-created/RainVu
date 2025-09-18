import "package:freezed_annotation/freezed_annotation.dart";
import "package:rain_wise/core/data/repositories/rainfall_repository.dart";
import "package:rain_wise/features/seasonal_patterns/data/seasonal_patterns_repository.dart";
import "package:rain_wise/features/seasonal_patterns/domain/seasonal_patterns_data.dart";
import "package:rain_wise/shared/domain/seasons.dart";
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
@riverpod
Future<SeasonalPatternsData> seasonalPatternsData(
  final Ref ref,
) async {
  ref.watch(rainfallRepositoryProvider).watchTableUpdates();

  final SeasonalFilter filter = ref.watch(seasonalPatternsFilterProvider);

  final SeasonalPatternsRepository repository =
      ref.watch(seasonalPatternsRepositoryProvider);
  return repository.fetchSeasonalPatterns(filter);
}
