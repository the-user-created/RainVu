import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rainvu/features/seasonal_trends/application/seasonal_trends_provider.dart";
import "package:rainvu/features/seasonal_trends/domain/seasonal_trends_data.dart";
import "package:rainvu/features/seasonal_trends/presentation/widgets/season_selector.dart";
import "package:rainvu/features/seasonal_trends/presentation/widgets/seasonal_summary_card.dart";
import "package:rainvu/features/seasonal_trends/presentation/widgets/seasonal_trend_chart.dart";
import "package:rainvu/l10n/app_localizations.dart";
import "package:rainvu/shared/widgets/buttons/app_icon_button.dart";
import "package:rainvu/shared/widgets/filter_bar.dart";
import "package:rainvu/shared/widgets/placeholders.dart";
import "package:rainvu/shared/widgets/sheets/info_sheet.dart";
import "package:shimmer/shimmer.dart";

class SeasonalTrendsScreen extends ConsumerWidget {
  const SeasonalTrendsScreen({super.key});

  void _showInfoSheet(final BuildContext context, final AppLocalizations l10n) {
    InfoSheet.show(
      context,
      title: l10n.seasonalTrendsInfoSheetTitle,
      items: [
        InfoSheetItem(
          icon: Icons.info_outline,
          title: "",
          description: l10n.seasonalTrendsInfoDescription,
        ),
        InfoSheetItem(
          icon: Icons.show_chart_outlined,
          title: l10n.seasonalTrendsInfoChartTitle,
          description: l10n.seasonalTrendsInfoChartDescription,
        ),
        InfoSheetItem(
          icon: Icons.summarize_outlined,
          title: l10n.seasonalTrendsInfoSummaryTitle,
          description: l10n.seasonalTrendsInfoSummaryDescription,
        ),
      ],
    );
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<SeasonalTrendsData> dataAsync = ref.watch(
      seasonalTrendsDataProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.seasonalTrendsTitle,
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
            const FilterBar(child: SeasonSelector()),
            Expanded(
              child: dataAsync.when(
                loading: () => const _LoadingState(),
                error: (final err, final stack) {
                  FirebaseCrashlytics.instance.recordError(
                    err,
                    stack,
                    reason: "Failed to load seasonal trends data",
                  );
                  return Center(child: Text(l10n.seasonalTrendsError));
                },
                data: (final data) {
                  final bool hasData =
                      data.summary.highestRecorded > 0 ||
                      data.summary.lowestRecorded > 0;

                  if (!hasData) {
                    return const _NoDataState();
                  }

                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      SeasonalTrendChart(trendData: data.trendData),
                      const SizedBox(height: 24),
                      SeasonalSummaryCard(summary: data.summary),
                    ],
                  );
                },
              ),
            ),
          ],
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
        padding: const EdgeInsets.all(16),
        children: const [
          CardPlaceholder(height: 300),
          SizedBox(height: 24),
          CardPlaceholder(height: 220),
        ],
      ),
    );
  }
}

/// A widget displayed when no seasonal data is available.
class _NoDataState extends StatelessWidget {
  const _NoDataState();

  @override
  Widget build(final BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_off_outlined,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.seasonalTrendsNoDataTitle,
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.seasonalTrendsNoDataMessage,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
