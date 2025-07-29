import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/insights/application/insights_providers.dart";
import "package:rain_wise/features/insights/domain/insights_data.dart";
import "package:rain_wise/features/insights/presentation/widgets/detailed_analysis_list.dart";
import "package:rain_wise/features/insights/presentation/widgets/key_metrics_section.dart";
import "package:rain_wise/features/insights/presentation/widgets/monthly_comparison_grid.dart";
import "package:rain_wise/features/insights/presentation/widgets/monthly_trend_chart.dart";
import "package:rain_wise/flutter_flow/flutter_flow_icon_button.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    final AsyncValue<InsightsData> insightsDataAsync =
        ref.watch(insightsScreenDataProvider);

    return Scaffold(
      backgroundColor: theme.secondaryBackground,
      appBar: AppBar(
        backgroundColor: theme.primaryBackground,
        automaticallyImplyLeading: false,
        title: Text(
          "Insights",
          style: theme.headlineMedium,
        ),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
            child: FlutterFlowIconButton(
              borderRadius: 50,
              buttonSize: 40,
              fillColor: theme.alternate,
              icon: Icon(
                Icons.info_outline,
                color: theme.primaryText,
                size: 24,
              ),
              onPressed: () {
                // TODO: Implement info dialog
              },
            ),
          ),
        ],
        centerTitle: false,
      ),
      body: insightsDataAsync.when(
        loading: () => const AppLoader(),
        error: (final err, final stack) => Center(child: Text("Error: $err")),
        data: (final data) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KeyMetricsSection(metrics: data.keyMetrics),
              const SizedBox(height: 24),
              MonthlyTrendChart(trends: data.monthlyTrends),
              const SizedBox(height: 24),
              MonthlyComparisonGrid(comparisons: data.monthlyComparisons),
              const SizedBox(height: 24),
              const DetailedAnalysisList(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
