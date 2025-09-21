import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/application/preferences_provider.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/seasonal_patterns/domain/seasonal_patterns_data.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/user_preferences.dart";

class SeasonalSummaryCard extends ConsumerWidget {
  const SeasonalSummaryCard({required this.summary, super.key});

  final SeasonalSummary summary;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final AppLocalizations l10n = AppLocalizations.of(context);
    final MeasurementUnit unit =
        ref.watch(userPreferencesProvider).value?.measurementUnit ??
        MeasurementUnit.mm;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.seasonSummaryTitle, style: textTheme.titleMedium),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MetricItem(
                  label: l10n.seasonSummaryAverageRainfallLabel,
                  value: summary.averageRainfall.formatRainfall(context, unit),
                  valueStyle: textTheme.headlineSmall,
                ),
                _VerticalDivider(),
                _TrendMetricItem(
                  label: l10n.seasonSummaryTrendVsHistoryLabel,
                  percentage: summary.trendVsHistory,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MetricItem(
                  label: l10n.seasonSummaryHighestRecordedLabel,
                  value: summary.highestRecorded.formatRainfall(context, unit),
                ),
                _VerticalDivider(),
                _MetricItem(
                  label: l10n.seasonSummaryLowestRecordedLabel,
                  value: summary.lowestRecorded.formatRainfall(context, unit),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({
    required this.label,
    required this.value,
    this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle? valueStyle;

  @override
  Widget build(final BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Text(value, style: valueStyle ?? textTheme.bodyLarge),
      ],
    );
  }
}

class _TrendMetricItem extends StatelessWidget {
  const _TrendMetricItem({required this.label, required this.percentage});

  final String label;
  final double percentage;

  @override
  Widget build(final BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isPositive = percentage >= 0;
    final Color color = isPositive ? colorScheme.tertiary : colorScheme.error;
    final IconData icon = isPositive ? Icons.trending_up : Icons.trending_down;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 8),
            Text(
              "${isPositive ? '+' : ''}${percentage.toStringAsFixed(0)}%",
              style: textTheme.headlineSmall?.copyWith(color: color),
            ),
          ],
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(final BuildContext context) => Container(
    width: 1,
    height: 40,
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
  );
}
