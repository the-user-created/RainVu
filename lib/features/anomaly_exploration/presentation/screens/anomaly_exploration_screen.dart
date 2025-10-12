import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/anomaly_exploration/application/anomaly_exploration_provider.dart";
import "package:rain_wise/features/anomaly_exploration/domain/anomaly_data.dart";
import "package:rain_wise/features/anomaly_exploration/presentation/widgets/anomaly_filter_options.dart";
import "package:rain_wise/features/anomaly_exploration/presentation/widgets/anomaly_list.dart";
import "package:rain_wise/features/anomaly_exploration/presentation/widgets/anomaly_timeline_chart.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";

class AnomalyExplorationScreen extends ConsumerWidget {
  const AnomalyExplorationScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<AnomalyExplorationData> anomalyDataAsync = ref.watch(
      anomalyDataProvider,
    );
    final TextScaler textScaler = MediaQuery.textScalerOf(context);
    final double verticalPadding = 24 * textScaler.scale(1);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.anomalyExplorationTitle,
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: verticalPadding),
                child: const AnomalyFilterOptions(),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: verticalPadding)),
            SliverToBoxAdapter(
              child: anomalyDataAsync.when(
                loading: () => AnomalyTimelineChart(
                  chartPoints: const [],
                  dateRange: DateTimeRange(
                    start: DateTime.now(),
                    end: DateTime.now(),
                  ),
                ),
                error: (final _, final _) => const SizedBox.shrink(),
                data: (final data) {
                  final AnomalyFilter filter = ref
                      .watch(anomalyFilterProvider)
                      .requireValue;
                  return AnomalyTimelineChart(
                    chartPoints: data.chartPoints,
                    dateRange: filter.dateRange,
                  );
                },
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: verticalPadding)),
            anomalyDataAsync.when(
              loading: () => const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: AppLoader()),
              ),
              error: (final err, final stack) => SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      l10n.anomalyExplorationError(err),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              data: (final data) => AnomalyList(
                anomalies: data.anomalies,
                chartPoints: data.chartPoints,
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: verticalPadding)),
          ],
        ),
      ),
    );
  }
}
