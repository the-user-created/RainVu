import "dart:math";

import "package:collection/collection.dart";
import "package:intl/intl.dart";
import "package:rain_wise/features/insights/domain/comparative_analysis_data.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "comparative_analysis_repository.g.dart";

abstract class ComparativeAnalysisRepository {
  Future<List<int>> getAvailableYears();

  Future<ComparativeAnalysisData> fetchComparativeData(
    final ComparativeFilter filter,
  );
}

@riverpod
ComparativeAnalysisRepository comparativeAnalysisRepository(
  final ComparativeAnalysisRepositoryRef ref,
) =>
    MockComparativeAnalysisRepository();

class MockComparativeAnalysisRepository
    implements ComparativeAnalysisRepository {
  @override
  Future<List<int>> getAvailableYears() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final int currentYear = DateTime.now().year;
    return List.generate(5, (final index) => currentYear - index);
  }

  @override
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
