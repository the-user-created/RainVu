import "package:flutter/material.dart";
import "package:rain_wise/l10n/app_localizations.dart";

class AnomalyTimelineChart extends StatelessWidget {
  const AnomalyTimelineChart({super.key});

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.rainfallTrendsTitle,
                  style: theme.textTheme.titleMedium,
                ),
                Row(
                  children: [
                    _LegendItem(
                      color: colorScheme.secondary.withValues(alpha: 0.5),
                      text: l10n.anomalyTimelineLegendNormal,
                    ),
                    const SizedBox(width: 8),
                    _LegendItem(
                      color: colorScheme.error,
                      text: l10n.anomalyTimelineLegendAnomaly,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 240,
              // TODO: Replace with real data from a provider
              // For now, this is a placeholder chart.
              child: Center(
                child: Text(
                  l10n.anomalyTimelineChartPlaceholder,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.text,
  });

  final Color color;
  final String text;

  @override
  Widget build(final BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(text, style: textTheme.bodySmall),
      ],
    );
  }
}
