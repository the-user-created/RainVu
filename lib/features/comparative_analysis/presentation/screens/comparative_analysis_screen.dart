import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/comparative_analysis/application/comparative_analysis_provider.dart";
import "package:rain_wise/features/comparative_analysis/domain/comparative_analysis_data.dart";
import "package:rain_wise/features/comparative_analysis/presentation/widgets/comparative_analysis_chart.dart";
import "package:rain_wise/features/comparative_analysis/presentation/widgets/comparative_analysis_filters.dart";
import "package:rain_wise/features/comparative_analysis/presentation/widgets/yearly_summary_list.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";

class ComparativeAnalysisScreen extends ConsumerWidget {
  const ComparativeAnalysisScreen({super.key});

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
          l10n.comparativeAnalysisTitle,
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: availableYearsAsync.when(
          loading: () => const Center(child: AppLoader()),
          error: (final err, final stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.comparativeAnalysisAvailableYearsError(err)),
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

class _AnalysisContent extends ConsumerWidget {
  const _AnalysisContent();

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<ComparativeAnalysisData> dataAsync = ref.watch(
      comparativeAnalysisDataProvider,
    );
    final Orientation orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.landscape) {
      return SingleChildScrollView(
        child: Column(
          children: [
            const ComparativeAnalysisFilters(),
            dataAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: AppLoader(),
              ),
              error: (final err, final stack) => Padding(
                padding: const EdgeInsets.all(32),
                child: Center(child: Text(l10n.comparativeAnalysisError(err))),
              ),
              data: (final data) {
                final bool hasNoDataForSelection =
                    data.summaries.isEmpty ||
                    (data.summaries.isNotEmpty &&
                        data.summaries.every(
                          (final s) => s.totalRainfall == 0,
                        ));

                if (hasNoDataForSelection) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: _NoDataForSelectionState(),
                  );
                }

                return Column(
                  children: [
                    ComparativeAnalysisChart(chartData: data.chartData),
                    YearlySummaryList(summaries: data.summaries),
                  ],
                );
              },
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        const ComparativeAnalysisFilters(),
        Expanded(
          child: dataAsync.when(
            loading: () => const Center(child: AppLoader()),
            error: (final err, final stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(l10n.comparativeAnalysisError(err)),
              ),
            ),
            data: (final data) {
              final bool hasNoDataForSelection =
                  data.summaries.isEmpty ||
                  (data.summaries.isNotEmpty &&
                      data.summaries.every((final s) => s.totalRainfall == 0));

              if (hasNoDataForSelection) {
                return const _NoDataForSelectionState();
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    ComparativeAnalysisChart(chartData: data.chartData),
                    YearlySummaryList(summaries: data.summaries),
                  ],
                ),
              );
            },
          ),
        ),
      ],
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
              l10n.comparativeAnalysisEmptyTitle,
              style: textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.comparativeAnalysisEmptyMessage,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
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
              l10n.comparativeAnalysisNoDataForSelection,
              style: textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
