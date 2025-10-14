import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rainly/core/application/preferences_provider.dart";
import "package:rainly/core/data/providers/data_providers.dart";
import "package:rainly/features/yearly_comparison/data/yearly_comparison_repository.dart";
import "package:rainly/features/yearly_comparison/domain/yearly_comparison_data.dart";
import "package:rainly/shared/domain/user_preferences.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "yearly_comparison_provider.g.dart";

@riverpod
Future<List<int>> availableYears(final Ref ref) async =>
    ref.watch(yearlyComparisonRepositoryProvider).getAvailableYears();

@riverpod
class YearlyComparisonFilterNotifier extends _$YearlyComparisonFilterNotifier {
  @override
  Future<ComparativeFilter> build() async {
    // Initialize with the two most recent years.
    final List<int> years = await ref.watch(availableYearsProvider.future);
    if (years.isEmpty) {
      // Handle case with no data to prevent crash.
      // The UI will show a "no data" state because availableYears is empty.
      final int currentYear = DateTime.now().year;
      return ComparativeFilter(year1: currentYear, year2: currentYear - 1);
    }
    if (years.length == 1) {
      // Only one year available, select it for both.
      // The UI will show a dedicated empty state for this scenario.
      return ComparativeFilter(year1: years.first, year2: years.first);
    }

    // Default to comparing the two most recent years, with the earlier year
    // on the left (year1) and the later year on the right (year2).
    // Note: availableYears is sorted descending.
    return ComparativeFilter(year1: years[1], year2: years.first);
  }

  Future<void> setYear1(final int year) async {
    final ComparativeFilter oldState = await future;
    state = AsyncData(oldState.copyWith(year1: year));
  }

  Future<void> setYear2(final int year) async {
    final ComparativeFilter oldState = await future;
    state = AsyncData(oldState.copyWith(year2: year));
  }

  Future<void> setType(final ComparisonType type) async {
    final ComparativeFilter oldState = await future;
    state = AsyncData(oldState.copyWith(type: type));
  }
}

/// A provider that memoizes the selected years.
/// It will only notify listeners if the years themselves change, ignoring
/// changes to the comparison type.
@riverpod
(int, int) _selectedYears(final Ref ref) => ref.watch(
  yearlyComparisonFilterProvider.select(
    (final f) => f.hasValue ? (f.value!.year1, f.value!.year2) : (0, 0),
  ),
);

/// Fetches only the yearly summary data.
/// This provider will only refetch when the selected years change.
@riverpod
Future<List<YearlySummary>> yearlyComparisonSummaries(final Ref ref) async {
  ref.watch(rainfallTableUpdatesProvider);

  final (int year1, int year2) = ref.watch(_selectedYearsProvider);

  // Await the filter to ensure we have valid years before proceeding.
  await ref.watch(yearlyComparisonFilterProvider.future);

  if (year1 == 0 || year2 == 0 || year1 == year2) {
    return [];
  }

  return ref
      .watch(yearlyComparisonRepositoryProvider)
      .fetchComparativeSummaries(year1, year2);
}

/// Fetches only the chart data.
/// This provider will refetch when any part of the filter changes (years or type).
@riverpod
Future<ComparativeChartData> yearlyComparisonChartData(final Ref ref) async {
  ref.watch(rainfallTableUpdatesProvider);

  // Await the filter provider. This will correctly propagate loading/error states.
  final ComparativeFilter filter = await ref.watch(
    yearlyComparisonFilterProvider.future,
  );
  final UserPreferences prefs = await ref.watch(userPreferencesProvider.future);

  if (filter.year1 == filter.year2) {
    // Return an empty state if the same year is selected for comparison.
    return const ComparativeChartData(labels: [], series: []);
  }
  return ref
      .watch(yearlyComparisonRepositoryProvider)
      .fetchComparativeChartData(filter, prefs.hemisphere);
}
