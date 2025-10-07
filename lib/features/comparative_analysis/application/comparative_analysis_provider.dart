import "package:rain_wise/core/application/preferences_provider.dart";
import "package:rain_wise/core/data/repositories/rainfall_repository.dart";
import "package:rain_wise/features/comparative_analysis/data/comparative_analysis_repository.dart";
import "package:rain_wise/features/comparative_analysis/domain/comparative_analysis_data.dart";
import "package:rain_wise/shared/domain/user_preferences.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "comparative_analysis_provider.g.dart";

@riverpod
Future<List<int>> availableYears(final Ref ref) async =>
    ref.watch(comparativeAnalysisRepositoryProvider).getAvailableYears();

@riverpod
class ComparativeAnalysisFilterNotifier
    extends _$ComparativeAnalysisFilterNotifier {
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

@riverpod
Future<ComparativeAnalysisData> comparativeAnalysisData(final Ref ref) async {
  ref.watch(rainfallRepositoryProvider).watchTableUpdates();

  // Await the filter provider. This will correctly propagate loading/error states.
  final ComparativeFilter filter = await ref.watch(
    comparativeAnalysisFilterProvider.future,
  );
  final UserPreferences prefs = await ref.watch(userPreferencesProvider.future);

  if (filter.year1 == filter.year2) {
    // Return an empty state if the same year is selected for comparison.
    return const ComparativeAnalysisData(
      summaries: [],
      chartData: ComparativeChartData(labels: [], series: []),
    );
  }
  return ref
      .watch(comparativeAnalysisRepositoryProvider)
      .fetchComparativeData(filter, prefs.hemisphere);
}
