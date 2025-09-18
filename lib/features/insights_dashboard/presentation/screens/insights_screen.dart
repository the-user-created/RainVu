import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/insights_dashboard/application/insights_providers.dart";
import "package:rain_wise/features/insights_dashboard/domain/insights_data.dart";
import "package:rain_wise/features/insights_dashboard/presentation/widgets/detailed_analysis_list.dart";
import "package:rain_wise/features/insights_dashboard/presentation/widgets/key_metrics_section.dart";
import "package:rain_wise/features/insights_dashboard/presentation/widgets/monthly_comparison_grid.dart";
import "package:rain_wise/features/insights_dashboard/presentation/widgets/monthly_trend_chart.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<InsightsData> insightsDataAsync =
        ref.watch(insightsScreenDataProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          l10n.navInsights,
          style: theme.textTheme.headlineLarge,
        ),
        centerTitle: false,
      ),
      body: insightsDataAsync.when(
        loading: () => const AppLoader(),
        error: (final err, final stack) =>
            Center(child: Text(l10n.insightsError(err))),
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
