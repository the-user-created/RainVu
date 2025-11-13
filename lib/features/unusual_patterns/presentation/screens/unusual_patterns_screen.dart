import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rainvu/features/unusual_patterns/application/unusual_patterns_provider.dart";
import "package:rainvu/features/unusual_patterns/domain/unusual_patterns_data.dart";
import "package:rainvu/features/unusual_patterns/presentation/widgets/unusual_patterns_filters.dart";
import "package:rainvu/features/unusual_patterns/presentation/widgets/unusual_patterns_list.dart";
import "package:rainvu/features/unusual_patterns/presentation/widgets/unusual_patterns_timeline_chart.dart";
import "package:rainvu/l10n/app_localizations.dart";
import "package:rainvu/shared/widgets/buttons/app_icon_button.dart";
import "package:rainvu/shared/widgets/filter_bar.dart";
import "package:rainvu/shared/widgets/placeholders.dart";
import "package:rainvu/shared/widgets/sheets/info_sheet.dart";
import "package:shimmer/shimmer.dart";

class UnusualPatternsScreen extends ConsumerWidget {
  const UnusualPatternsScreen({super.key});

  void _showInfoSheet(final BuildContext context, final AppLocalizations l10n) {
    InfoSheet.show(
      context,
      title: l10n.unusualPatternsInfoSheetTitle,
      items: [
        InfoSheetItem(
          icon: Icons.help_outline,
          title: l10n.unusualPatternsInfoAnomalyTitle,
          description: l10n.unusualPatternsInfoAnomalyDescription,
        ),
        InfoSheetItem(
          icon: Icons.warning_amber_outlined,
          title: l10n.unusualPatternsInfoSeverityTitle,
          description: l10n.unusualPatternsInfoSeverityDescription,
        ),
        InfoSheetItem(
          icon: Icons.show_chart_outlined,
          title: l10n.unusualPatternsInfoChartTitle,
          description: l10n.unusualPatternsInfoChartDescription,
        ),
      ],
    );
  }

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: AppIconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => _showInfoSheet(context, l10n),
              tooltip: l10n.infoTooltip,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const FilterBar(child: UnusualPatternsFilters()),
            Expanded(
              child: CustomScrollView(
                slivers: [
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
                    error: (final err, final stack) {
                      FirebaseCrashlytics.instance.recordError(
                        err,
                        stack,
                        reason: "Failed to load anomaly data",
                      );
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              l10n.unusualPatternsError,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                    data: (final data) => AnomalyList(
                      anomalies: data.anomalies,
                      chartPoints: data.chartPoints,
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: verticalPadding)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
