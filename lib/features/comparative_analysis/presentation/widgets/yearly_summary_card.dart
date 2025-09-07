import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/comparative_analysis/domain/comparative_analysis_data.dart";
import "package:rain_wise/features/settings/application/preferences_provider.dart";
import "package:rain_wise/features/settings/domain/user_preferences.dart";
import "package:rain_wise/l10n/app_localizations.dart";

class YearlySummaryCard extends ConsumerWidget {
  const YearlySummaryCard({
    required this.summary,
    required this.color,
    super.key,
  });

  final YearlySummary summary;
  final Color color;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final bool isPositive = summary.percentageChange >= 0;
    final Color changeColor =
        isPositive ? colorScheme.tertiary : colorScheme.error;
    final IconData changeIcon =
        isPositive ? Icons.trending_up : Icons.trending_down;
    final MeasurementUnit unit =
        ref.watch(userPreferencesNotifierProvider).value?.measurementUnit ??
            MeasurementUnit.mm;

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  summary.year.toString(),
                  style: textTheme.headlineSmall?.copyWith(
                    color: color,
                  ),
                ),
                if (summary.percentageChange.isFinite &&
                    summary.percentageChange != 0)
                  Row(
                    children: [
                      Icon(changeIcon, color: changeColor, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${isPositive ? '+' : ''}${summary.percentageChange.toStringAsFixed(0)}%',
                        style: textTheme.bodyMedium?.copyWith(
                          color: changeColor,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _StatItem(
                  label: l10n.yearlySummaryTotalAnnualRainfall,
                  value: summary.totalRainfall.formatRainfall(context, unit),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.titleMedium,
        ),
      ],
    );
  }
}
