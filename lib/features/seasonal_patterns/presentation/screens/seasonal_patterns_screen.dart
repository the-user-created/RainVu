import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/seasonal_patterns/application/seasonal_patterns_provider.dart";
import "package:rain_wise/features/seasonal_patterns/domain/seasonal_patterns_data.dart";
import "package:rain_wise/features/seasonal_patterns/presentation/widgets/season_selector.dart";
import "package:rain_wise/features/seasonal_patterns/presentation/widgets/seasonal_summary_card.dart";
import "package:rain_wise/features/seasonal_patterns/presentation/widgets/seasonal_trend_chart.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";

class SeasonalPatternsScreen extends ConsumerWidget {
  const SeasonalPatternsScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<SeasonalPatternsData> dataAsync = ref.watch(
      seasonalPatternsDataProvider,
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        shadowColor: theme.shadowColor,
        title: Text(
          l10n.seasonalPatternsTitle,
          style: theme.textTheme.headlineMedium,
        ),
        centerTitle: false,
      ),
      body: dataAsync.when(
        loading: () => const Center(child: AppLoader()),
        error: (final err, final stack) =>
            Center(child: Text(l10n.seasonalPatternsError(err))),
        data: (final data) {
          final bool hasData =
              data.summary.highestRecorded > 0 ||
              data.summary.lowestRecorded > 0;

          return ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              const _Header(),
              const SizedBox(height: 24),
              if (hasData)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      SeasonalTrendChart(trendData: data.trendData),
                      const SizedBox(height: 24),
                      SeasonalSummaryCard(summary: data.summary),
                    ],
                  ),
                )
              else
                const _NoDataState(),
            ],
          );
        },
      ),
    );
  }
}

/// The header section containing description and filters.
class _Header extends ConsumerWidget {
  const _Header();

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: theme.shadowColor.withValues(alpha: 0.2),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.seasonalPatternsDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            const SeasonSelector(),
          ],
        ),
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
            l10n.seasonalPatternsNoDataTitle,
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.seasonalPatternsNoDataMessage,
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
