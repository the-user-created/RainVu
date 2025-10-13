import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/insights_dashboard/application/insights_providers.dart";
import "package:rain_wise/features/insights_dashboard/domain/insights_data.dart";
import "package:rain_wise/features/insights_dashboard/presentation/widgets/analysis_links_section.dart";
import "package:rain_wise/features/insights_dashboard/presentation/widgets/insights_history_chart.dart";
import "package:rain_wise/features/insights_dashboard/presentation/widgets/metric_header.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<InsightsData> asyncData = ref.watch(dashboardDataProvider);
    final MetricData? metricData = ref.watch(currentMetricDataProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n.navInsights, style: theme.textTheme.headlineLarge),
      ),
      body: SafeArea(
        child: asyncData.when(
          loading: () => const AppLoader(),
          error: (final err, final stack) =>
              Center(child: Text(l10n.insightsError(err))),
          data: (final data) {
            // Check if there is any meaningful data to display
            if (data.allTimeData.primaryValue == 0) {
              return const _EmptyState();
            }

            return ListView(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              children: [
                const MetricHeader(),
                const SizedBox(height: 24),
                if (metricData != null)
                  HistoricalChart(points: metricData.chartPoints),
                const SizedBox(height: 32),
                const AnalysisLinksSection(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.insights,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.dashboardNoDataTitle,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.dashboardNoDataMessage,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
