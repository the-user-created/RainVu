import "dart:math";

import "package:collection/collection.dart";
import "package:intl/intl.dart";
import "package:rain_wise/features/insights/domain/comparative_analysis_data.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "comparative_analysis_provider.g.dart";

// --- Mock Repository ---
// In a real app, this would be in the data layer.
class _MockComparativeAnalysisRepository {
  Future<List<int>> getAvailableYears() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final int currentYear = DateTime.now().year;
    return List.generate(5, (final index) => currentYear - index);
  }

  Future<ComparativeAnalysisData> fetchComparativeData(
    final ComparativeFilter filter,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final random = Random();

    final List<String> labels = DateFormat.MMMM()
        .dateSymbols
        .STANDALONEMONTHS
        .map((final m) => m.substring(0, 3))
        .toList();
    final List<double> data1 =
        List.generate(12, (final _) => random.nextDouble() * 100 + 20);
    final List<double> data2 =
        List.generate(12, (final _) => random.nextDouble() * 100 + 20);

    final chartData = ComparativeChartData(
      labels: labels,
      series: [
        ComparativeChartSeries(year: filter.year1, data: data1),
        ComparativeChartSeries(year: filter.year2, data: data2),
      ],
    );

    final double total1 = data1.sum;
    final double total2 = data2.sum;
    final double change1vs2 =
        total2 != 0 ? ((total1 - total2) / total2) * 100 : 0.0;
    final double change2vs1 =
        total1 != 0 ? ((total2 - total1) / total1) * 100 : 0.0;

    final summaries = [
      YearlySummary(
        year: filter.year1,
        totalRainfall: total1,
        percentageChange: change1vs2,
      ),
      YearlySummary(
        year: filter.year2,
        totalRainfall: total2,
        percentageChange: change2vs1,
      ),
    ];

    return ComparativeAnalysisData(
      summaries: summaries,
      chartData: chartData,
    );
  }
}

@riverpod
_MockComparativeAnalysisRepository mockComparativeAnalysisRepository(
  final MockComparativeAnalysisRepositoryRef ref,
) =>
    _MockComparativeAnalysisRepository();
// --- End Mock Repository ---

@riverpod
Future<List<int>> availableYears(final AvailableYearsRef ref) async =>
    ref.watch(mockComparativeAnalysisRepositoryProvider).getAvailableYears();

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
      .watch(mockComparativeAnalysisRepositoryProvider)
      .fetchComparativeData(filter);
}
