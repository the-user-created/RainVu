import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:rain_wise/core/application/preferences_provider.dart";
import "package:rain_wise/core/data/repositories/rainfall_repository.dart";
import "package:rain_wise/features/seasonal_patterns/data/seasonal_patterns_repository.dart";
import "package:rain_wise/features/seasonal_patterns/domain/seasonal_patterns_data.dart";
import "package:rain_wise/shared/domain/seasons.dart";
import "package:rain_wise/shared/domain/user_preferences.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "seasonal_patterns_provider.g.dart";

part "seasonal_patterns_provider.freezed.dart";

@freezed
abstract class SeasonalFilter with _$SeasonalFilter {
  const factory SeasonalFilter({
    required final int year,
    required final Season season,
  }) = _SeasonalFilter;
}

@riverpod
class SeasonalPatternsFilterNotifier extends _$SeasonalPatternsFilterNotifier {
  @override
  SeasonalFilter build() {
    // Set the initial season based on the user's hemisphere preference.
    final Hemisphere hemisphere =
        ref.watch(
          userPreferencesProvider.select(
            (final pref) => pref.value?.hemisphere,
          ),
        ) ??
        Hemisphere.northern;

    return SeasonalFilter(
      year: DateTime.now().year,
      season: getCurrentSeason(hemisphere),
    );
  }

  void setFilter(final Season season, final int year) {
    state = SeasonalFilter(season: season, year: year);
  }
}

/// Fetches seasonal patterns data based on the current filter and hemisphere.
@riverpod
Future<SeasonalPatternsData> seasonalPatternsData(final Ref ref) async {
  ref.watch(rainfallRepositoryProvider).watchTableUpdates();

  final SeasonalFilter filter = ref.watch(seasonalPatternsFilterProvider);
  // Await preferences to ensure they are loaded before fetching data.
  final UserPreferences prefs = await ref.watch(userPreferencesProvider.future);

  final SeasonalPatternsRepository repository = ref.watch(
    seasonalPatternsRepositoryProvider,
  );
  return repository.fetchSeasonalPatterns(filter, prefs.hemisphere);
}

/// Provides a list of years for which rainfall data is available.
@riverpod
Future<List<int>> availableYears(final Ref ref) async {
  final List<int> years = await ref
      .watch(rainfallRepositoryProvider)
      .getAvailableYears();
  // Ensure the list is sorted descending for the UI dropdown.
  years.sort((final a, final b) => b.compareTo(a));
  return years;
}
