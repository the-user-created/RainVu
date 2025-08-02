import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:rain_wise/features/insights/application/anomaly_exploration_provider.dart";
import "package:rain_wise/features/insights/domain/anomaly_data.dart";
import "package:rain_wise/features/insights/presentation/widgets/anomaly_exploration/anomaly_filter_options.dart";
import "package:rain_wise/features/insights/presentation/widgets/anomaly_exploration/anomaly_list.dart";
import "package:rain_wise/features/insights/presentation/widgets/anomaly_exploration/anomaly_timeline_chart.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";
import "package:rain_wise/shared/widgets/buttons/app_icon_button.dart";

class AnomalyExplorationScreen extends ConsumerWidget {
  const AnomalyExplorationScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AsyncValue<List<RainfallAnomaly>> anomaliesAsync =
        ref.watch(anomalyDataProvider);

    return Scaffold(
      appBar: AppBar(
        leading: AppIconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: context.pop,
          tooltip: "Back",
        ),
        title:
            Text("Anomaly Exploration", style: theme.textTheme.headlineMedium),
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
                child: Text("Error loading anomalies: $err"),
              ),
              data: (final anomalies) => AnomalyList(anomalies: anomalies),
            ),
          ],
        ),
      ),
    );
  }
}
