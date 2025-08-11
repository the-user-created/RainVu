import "package:rain_wise/features/comparative_analysis/data/comparative_analysis_repository.dart";
import "package:rain_wise/features/comparative_analysis/domain/comparative_analysis_data.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "comparative_analysis_provider.g.dart";

@riverpod
Future<List<int>> availableYears(final AvailableYearsRef ref) async =>
    ref.watch(comparativeAnalysisRepositoryProvider).getAvailableYears();

@riverpod
class ComparativeAnalysisFilterNotifier
    extends _$ComparativeAnalysisFilterNotifier {
  @override
  Future<ComparativeFilter> build() async {
    // Initialize with the two most recent years.
    final List<int> years = await ref.watch(availableYearsProvider.future);
    return ComparativeFilter(
      year1: years.first,
      year2: years.length > 1 ? years[1] : years.first,
    );
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
Future<ComparativeAnalysisData> comparativeAnalysisData(
  final ComparativeAnalysisDataRef ref,
) async {
  // Await the filter provider. This will correctly propagate loading/error states.
  final ComparativeFilter filter =
      await ref.watch(comparativeAnalysisFilterNotifierProvider.future);

  if (filter.year1 == filter.year2) {
    // Return an empty state if the same year is selected for comparison.
    return const ComparativeAnalysisData(
      summaries: [],
      chartData: ComparativeChartData(labels: [], series: []),
    );
  }
  return ref
      .watch(comparativeAnalysisRepositoryProvider)
      .fetchComparativeData(filter);
}
