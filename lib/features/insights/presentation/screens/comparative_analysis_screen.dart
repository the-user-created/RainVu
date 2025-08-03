import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:rain_wise/features/insights/application/comparative_analysis_provider.dart";
import "package:rain_wise/features/insights/domain/comparative_analysis_data.dart";
import "package:rain_wise/features/insights/presentation/widgets/comparative_analysis/comparative_analysis_chart.dart";
import "package:rain_wise/features/insights/presentation/widgets/comparative_analysis/comparative_analysis_filters.dart";
import "package:rain_wise/features/insights/presentation/widgets/comparative_analysis/yearly_summary_list.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";
import "package:rain_wise/shared/widgets/buttons/app_icon_button.dart";

class ComparativeAnalysisScreen extends ConsumerWidget {
  const ComparativeAnalysisScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AsyncValue<ComparativeAnalysisData> dataAsync =
        ref.watch(comparativeAnalysisDataProvider);

    return Scaffold(
      appBar: AppBar(
        leading: AppIconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: theme.colorScheme.onSurface,
            size: 30,
          ),
          onPressed: context.pop,
          tooltip: "Back",
        ),
        title: Text(
          "Comparative Analysis",
          style: theme.textTheme.headlineMedium,
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: Column(
        children: [
          const ComparativeAnalysisFilters(),
          Expanded(
            child: dataAsync.when(
              loading: () => const Center(child: AppLoader()),
              error: (final err, final stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text("An error occurred: $err"),
                ),
              ),
              data: (final data) {
                if (data.summaries.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        "Please select two different years to compare.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ComparativeAnalysisChart(chartData: data.chartData),
                      YearlySummaryList(summaries: data.summaries),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
