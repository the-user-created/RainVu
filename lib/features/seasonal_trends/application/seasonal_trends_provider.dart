import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:rainvu/core/application/preferences_provider.dart";
import "package:rainvu/core/data/repositories/rainfall_repository.dart";
import "package:rainvu/features/seasonal_trends/data/seasonal_trends_repository.dart";
import "package:rainvu/features/seasonal_trends/domain/seasonal_trends_data.dart";
import "package:rainvu/shared/domain/seasons.dart";
import "package:rainvu/shared/domain/user_preferences.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "seasonal_trends_provider.g.dart";

part "seasonal_trends_provider.freezed.dart";

@freezed
abstract class SeasonalFilter with _$SeasonalFilter {
  const factory SeasonalFilter({
    required final int year,
    required final Season season,
  }) = _SeasonalFilter;
}

@riverpod
class SeasonalTrendsFilterNotifier extends _$SeasonalTrendsFilterNotifier {
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
Future<SeasonalTrendsData> seasonalTrendsData(final Ref ref) async {
  ref.watch(rainfallRepositoryProvider).watchTableUpdates();

  final SeasonalFilter filter = ref.watch(seasonalTrendsFilterProvider);
  // Await preferences to ensure they are loaded before fetching data.
  final UserPreferences prefs = await ref.watch(userPreferencesProvider.future);

  final SeasonalTrendsRepository repository = ref.watch(
    seasonalTrendsRepositoryProvider,
  );
  return repository.fetchSeasonalTrends(filter, prefs.hemisphere);
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
