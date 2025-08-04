import "package:flutter/material.dart";
import "package:rain_wise/features/insights/domain/insights_data.dart";
import "package:rain_wise/l10n/app_localizations.dart";

class MtdBreakdownCard extends StatelessWidget {
  const MtdBreakdownCard({
    required this.data,
    super.key,
  });

  final MonthlyComparisonData data;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Card(
      elevation: 2,
      color: theme.colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              data.month,
              style: textTheme.titleMedium,
            ),
            _DataRow(
              label: l10n.mtdBreakdownTotal,
              value: l10n.valueInMm(data.mtdTotal.toString()),
            ),
            _ComparisonRow(
              label: l10n.mtdBreakdown2yrAvg,
              currentValue: data.mtdTotal,
              comparisonValue: data.twoYrAvg,
            ),
            _ComparisonRow(
              label: l10n.mtdBreakdown5yrAvg,
              currentValue: data.mtdTotal,
              comparisonValue: data.fiveYrAvg,
            ),
          ],
        ),
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  const _ComparisonRow({
    required this.label,
    required this.currentValue,
    required this.comparisonValue,
  });

  final String label;
  final int currentValue;
  final int comparisonValue;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ComparisonIcon(
              current: currentValue,
              comparison: comparisonValue,
            ),
            const SizedBox(width: 4),
            Text(
              l10n.valueInMm(comparisonValue.toString()),
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}

class _ComparisonIcon extends StatelessWidget {
  const _ComparisonIcon({required this.current, required this.comparison});

  final int current;
  final int comparison;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    if (comparison > current) {
      return Icon(Icons.arrow_upward, color: colorScheme.tertiary, size: 16);
    } else if (comparison < current) {
      return Icon(Icons.arrow_downward, color: colorScheme.error, size: 16);
    } else {
      return Icon(
        Icons.horizontal_rule,
        color: colorScheme.secondary,
        size: 16,
      );
    }
  }
}
