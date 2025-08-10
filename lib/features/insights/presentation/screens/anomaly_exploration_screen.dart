import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/insights/application/anomaly_exploration_provider.dart";
import "package:rain_wise/features/insights/domain/anomaly_data.dart";
import "package:rain_wise/features/insights/presentation/widgets/anomaly_exploration/anomaly_filter_options.dart";
import "package:rain_wise/features/insights/presentation/widgets/anomaly_exploration/anomaly_list.dart";
import "package:rain_wise/features/insights/presentation/widgets/anomaly_exploration/anomaly_timeline_chart.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";

class AnomalyExplorationScreen extends ConsumerWidget {
  const AnomalyExplorationScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<List<RainfallAnomaly>> anomaliesAsync =
        ref.watch(anomalyDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.anomalyExplorationTitle,
          style: theme.textTheme.headlineMedium,
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            const AnomalyFilterOptions(),
            const SizedBox(height: 24),
            const AnomalyTimelineChart(),
            const SizedBox(height: 24),
            anomaliesAsync.when(
              loading: () => const Center(heightFactor: 5, child: AppLoader()),
              error: (final err, final stack) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text(l10n.anomalyExplorationError(err)),
              ),
              data: (final anomalies) => AnomalyList(anomalies: anomalies),
            ),
          ],
        ),
      ),
    );
  }
}
