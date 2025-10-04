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
    final AsyncValue<AnomalyExplorationData> anomalyExplorationDataAsync = ref
        .watch(anomalyDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.anomalyExplorationTitle,
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              const AnomalyFilterOptions(),
              const SizedBox(height: 24),
              anomalyExplorationDataAsync.when(
                loading: () => const AnomalyTimelineChart(
                  chartPoints: [],
                ),
                error: (final err, final stack) =>
                    const SizedBox.shrink(),
                data: (final data) =>
                    AnomalyTimelineChart(chartPoints: data.chartPoints),
              ),
              const SizedBox(height: 24),
              anomalyExplorationDataAsync.when(
                loading: () =>
                    const Center(heightFactor: 5, child: AppLoader()),
                error: (final err, final stack) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(l10n.anomalyExplorationError(err)),
                ),
                data: (final data) => AnomalyList(anomalies: data.anomalies),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
