import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rainly/core/application/preferences_provider.dart";
import "package:rainly/core/ui/custom_colors.dart";
import "package:rainly/core/utils/extensions.dart";
import "package:rainly/features/daily_breakdown/domain/daily_breakdown_data.dart";
import "package:rainly/l10n/app_localizations.dart";
import "package:rainly/shared/domain/user_preferences.dart";

class PastAveragesCard extends ConsumerWidget {
  const PastAveragesCard({
    required this.stats,
    required this.currentTotal,
    super.key,
  });

  final PastAveragesStats stats;
  final double currentTotal;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final AppLocalizations l10n = AppLocalizations.of(context);
    final MeasurementUnit unit =
        ref.watch(userPreferencesProvider).value?.measurementUnit ??
        MeasurementUnit.mm;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.historicalComparisonTitle, style: textTheme.titleMedium),
            const SizedBox(height: 16),
            _ComparisonRow(
              label: l10n.twoYearAverage,
              avgValue: stats.twoYearAvg,
              currentValue: currentTotal,
              unit: unit,
            ),
            const SizedBox(height: 12),
            _ComparisonRow(
              label: l10n.fiveYearAverage,
              avgValue: stats.fiveYearAvg,
              currentValue: currentTotal,
              unit: unit,
            ),
            const SizedBox(height: 12),
            _ComparisonRow(
              label: l10n.tenYearAverage,
              avgValue: stats.tenYearAvg,
              currentValue: currentTotal,
              unit: unit,
            ),
          ],
        ),
      ),
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  const _ComparisonRow({
    required this.label,
    required this.avgValue,
    required this.currentValue,
    this.unit = MeasurementUnit.mm,
  });

  final String label;
  final double avgValue;
  final double currentValue;
  final MeasurementUnit unit;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final double diff = currentValue - avgValue;
    final double percentage = avgValue == 0 ? 0.0 : (diff / avgValue) * 100;
    final Color color = diff >= 0 ? colorScheme.success : colorScheme.error;
    final IconData icon = diff >= 0 ? Icons.arrow_upward : Icons.arrow_downward;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: textTheme.bodyMedium),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(icon, color: color, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    percentage.formatPercentage(
                      precision: 0,
                      showPositiveSign: true,
                    ),
                    style: textTheme.bodyMedium?.copyWith(color: color),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          flex: 2,
          child: Text(
            avgValue.formatRainfall(context, unit),
            style: textTheme.bodyMedium,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
