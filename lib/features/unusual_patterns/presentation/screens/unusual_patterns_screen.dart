import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/unusual_patterns/application/unusual_patterns_provider.dart";
import "package:rain_wise/features/unusual_patterns/domain/unusual_patterns_data.dart";
import "package:rain_wise/features/unusual_patterns/presentation/widgets/unusual_patterns_filter_options.dart";
import "package:rain_wise/features/unusual_patterns/presentation/widgets/unusual_patterns_list.dart";
import "package:rain_wise/features/unusual_patterns/presentation/widgets/unusual_patterns_timeline_chart.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/widgets/placeholders.dart";
import "package:shimmer/shimmer.dart";

class UnusualPatternsScreen extends ConsumerWidget {
  const UnusualPatternsScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<UnusualPatternsData> anomalyDataAsync = ref.watch(
      anomalyDataProvider,
    );
    final TextScaler textScaler = MediaQuery.textScalerOf(context);
    final double verticalPadding = 24 * textScaler.scale(1);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.unusualPatternsTitle,
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
                loading: () => Shimmer.fromColors(
                  baseColor: theme.colorScheme.surfaceContainerHighest,
                  highlightColor: theme.colorScheme.surface,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: CardPlaceholder(height: 280),
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
              loading: () => SliverToBoxAdapter(
                child: Shimmer.fromColors(
                  baseColor: theme.colorScheme.surfaceContainerHighest,
                  highlightColor: theme.colorScheme.surface,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        CardPlaceholder(height: 120),
                        SizedBox(height: 12),
                        CardPlaceholder(height: 120),
                        SizedBox(height: 12),
                        CardPlaceholder(height: 120),
                      ],
                    ),
                  ),
                ),
              ),
              error: (final err, final stack) => SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      l10n.unusualPatternsError(err),
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
