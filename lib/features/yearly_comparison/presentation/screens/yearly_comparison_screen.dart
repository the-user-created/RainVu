import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/yearly_comparison/application/yearly_comparison_provider.dart";
import "package:rain_wise/features/yearly_comparison/domain/yearly_comparison_data.dart";
import "package:rain_wise/features/yearly_comparison/presentation/widgets/yearly_comparison_chart.dart";
import "package:rain_wise/features/yearly_comparison/presentation/widgets/yearly_comparison_filters.dart";
import "package:rain_wise/features/yearly_comparison/presentation/widgets/yearly_summary_list.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/widgets/buttons/app_icon_button.dart";
import "package:rain_wise/shared/widgets/placeholders.dart";
import "package:rain_wise/shared/widgets/sheets/info_sheet.dart";
import "package:shimmer/shimmer.dart";

class YearlyComparisonScreen extends ConsumerWidget {
  const YearlyComparisonScreen({super.key});

  void _showInfoSheet(final BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    InfoSheet.show(
      context,
      title: l10n.comparisonInfoSheetTitle,
      items: [
        InfoSheetItem(
          icon: Icons.calendar_today,
          title: l10n.comparisonInfoAnnualTitle,
          description: l10n.comparisonInfoAnnualDescription,
        ),
        InfoSheetItem(
          icon: Icons.bar_chart,
          title: l10n.comparisonInfoMonthlyTitle,
          description: l10n.comparisonInfoMonthlyDescription,
        ),
        InfoSheetItem(
          icon: Icons.eco,
          title: l10n.comparisonInfoSeasonalTitle,
          description: l10n.comparisonInfoSeasonalDescription,
        ),
      ],
    );
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<List<int>> availableYearsAsync = ref.watch(
      availableYearsProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.yearlyComparisonTitle,
          style: theme.textTheme.titleLarge,
        ),
        actions: [
          availableYearsAsync.when(
            data: (final years) => years.length < 2
                ? const SizedBox.shrink()
                : AppIconButton(
                    icon: const Icon(Icons.info_outline),
                    tooltip: l10n.infoTooltip,
                    onPressed: () => _showInfoSheet(context),
                  ),
            error: (final _, final _) => const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: availableYearsAsync.when(
          loading: () => const _LoadingState(),
          error: (final err, final stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.yearlyComparisonAvailableYearsError(err)),
            ),
          ),
          data: (final availableYears) {
            if (availableYears.length < 2) {
              return const _InsufficientDataState();
            }

            return const _AnalysisContent();
          },
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Shimmer.fromColors(
      baseColor: theme.colorScheme.surfaceContainerHighest,
      highlightColor: theme.colorScheme.surface,
      child: const SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            YearlyComparisonFilters(),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: CardPlaceholder(height: 300),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  CardPlaceholder(height: 100),
                  SizedBox(height: 12),
                  CardPlaceholder(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalysisContent extends StatelessWidget {
  const _AnalysisContent();

  @override
  Widget build(final BuildContext context) => const SingleChildScrollView(
    child: Column(children: [YearlyComparisonFilters(), _DataContent()]),
  );
}

class _DataContent extends ConsumerWidget {
  const _DataContent();

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<List<YearlySummary>> summariesAsync = ref.watch(
      yearlyComparisonSummariesProvider,
    );
    final theme = Theme.of(context);
    final List<YearlySummary>? summaries = summariesAsync.value;

    // Only show the loader on the initial fetch or handle errors.
    if (summaries == null) {
      return summariesAsync.when(
        // The loader will only be shown on the very first load.
        loading: () => Shimmer.fromColors(
          baseColor: theme.colorScheme.surfaceContainerHighest,
          highlightColor: theme.colorScheme.surface,
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                CardPlaceholder(height: 300),
                SizedBox(height: 16),
                CardPlaceholder(height: 100),
                SizedBox(height: 12),
                CardPlaceholder(height: 100),
              ],
            ),
          ),
        ),
        error: (final err, final stack) => Padding(
          padding: const EdgeInsets.all(32),
          child: Center(child: Text(l10n.yearlyComparisonError(err))),
        ),
        // This case is needed for the `when` but won't be hit if summaries is null.
        data: (final data) => const SizedBox.shrink(),
      );
    }

    // If we have data (new or old), build the UI.
    final bool hasNoDataForSelection =
        summaries.isEmpty ||
        (summaries.isNotEmpty &&
            summaries.every((final s) => s.totalRainfall == 0));

    if (hasNoDataForSelection) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: _NoDataForSelectionState(),
      );
    }

    return Column(
      children: [
        const _YearlyComparisonChartLoader(),
        YearlySummaryList(summaries: summaries),
      ],
    );
  }
}

class _YearlyComparisonChartLoader extends ConsumerWidget {
  const _YearlyComparisonChartLoader();

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<ComparativeChartData> chartDataAsync = ref.watch(
      yearlyComparisonChartDataProvider,
    );
    final theme = Theme.of(context);
    final ComparativeChartData? chartData = chartDataAsync.value;

    // If we have data (new or old), show the chart. The chart's internal
    // animation will handle the transition smoothly.
    if (chartData != null) {
      return YearlyComparisonChart(chartData: chartData);
    }

    // Otherwise, it's the initial load or an error. Handle these states.
    return chartDataAsync.when(
      loading: () => SizedBox(
        height: 332,
        child: Shimmer.fromColors(
          baseColor: theme.colorScheme.surfaceContainerHighest,
          highlightColor: theme.colorScheme.surface,
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: CardPlaceholder(height: 300),
          ),
        ),
      ),
      error: (final err, final stack) => Padding(
        padding: const EdgeInsets.all(32),
        child: Center(child: Text(l10n.yearlyComparisonError(err))),
      ),
      // This data case is technically covered by the `if (chartData != null)`
      // check above, but is required by the `when` method.
      data: (final data) => YearlyComparisonChart(chartData: data),
    );
  }
}

class _InsufficientDataState extends StatelessWidget {
  const _InsufficientDataState();

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 64,
              color: colorScheme.onSurfaceVariant.withAlpha(128),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.yearlyComparisonEmptyTitle,
              style: textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.yearlyComparisonEmptyMessage,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate().fade(duration: 500.ms).scale(begin: const Offset(0.95, 0.95));
  }
}

class _NoDataForSelectionState extends StatelessWidget {
  const _NoDataForSelectionState();

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.data_exploration_outlined,
              size: 64,
              color: colorScheme.onSurfaceVariant.withAlpha(128),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.yearlyComparisonNoDataForSelection,
              style: textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate().fade(duration: 500.ms).scale(begin: const Offset(0.95, 0.95));
  }
}
