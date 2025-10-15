import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rainvu/features/insights_dashboard/application/insights_providers.dart";
import "package:rainvu/features/insights_dashboard/domain/insights_data.dart";
import "package:rainvu/features/insights_dashboard/presentation/widgets/analysis_links_section.dart";
import "package:rainvu/features/insights_dashboard/presentation/widgets/insights_history_chart.dart";
import "package:rainvu/features/insights_dashboard/presentation/widgets/metric_header.dart";
import "package:rainvu/l10n/app_localizations.dart";
import "package:rainvu/shared/widgets/placeholders.dart";
import "package:shimmer/shimmer.dart";

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
          loading: () => const _LoadingState(),
          error: (final err, final stack) {
            FirebaseCrashlytics.instance.recordError(
              err,
              stack,
              reason: "Failed to load insights dashboard data",
            );
            return Center(child: Text(l10n.insightsError));
          },
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

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Shimmer.fromColors(
      baseColor: theme.colorScheme.surfaceContainerHighest,
      highlightColor: theme.colorScheme.surface,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 8, bottom: 24, left: 16, right: 16),
        children: const [
          // Metric Header Placeholder
          Column(
            children: [
              LinePlaceholder(height: 44, width: 200),
              SizedBox(height: 8),
              LinePlaceholder(height: 14, width: 150),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LinePlaceholder(
                    height: 36,
                    width: 80,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  SizedBox(width: 8),
                  LinePlaceholder(
                    height: 36,
                    width: 80,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  SizedBox(width: 8),
                  LinePlaceholder(
                    height: 36,
                    width: 80,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  SizedBox(width: 8),
                  LinePlaceholder(
                    height: 36,
                    width: 80,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 24),
          // Chart Placeholder
          CardPlaceholder(height: 300),
          SizedBox(height: 32),
          // Analysis Links Placeholder
          LinePlaceholder(height: 20, width: 150),
          SizedBox(height: 12),
          CardPlaceholder(height: 80),
          SizedBox(height: 12),
          CardPlaceholder(height: 80),
          SizedBox(height: 12),
          CardPlaceholder(height: 80),
        ],
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
