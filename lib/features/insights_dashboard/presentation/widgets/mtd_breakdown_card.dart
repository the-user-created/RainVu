import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/application/preferences_provider.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/insights_dashboard/domain/insights_data.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/user_preferences.dart";

class MtdBreakdownCard extends ConsumerWidget {
  const MtdBreakdownCard({required this.data, super.key});

  final MonthlyComparisonData data;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final AppLocalizations l10n = AppLocalizations.of(context);
    final MeasurementUnit unit =
        ref.watch(userPreferencesProvider).value?.measurementUnit ??
        MeasurementUnit.mm;

    return Card(
      elevation: 2,
      color: theme.colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                data.month,
                style: textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            _DataRow(
              label: l10n.mtdBreakdownTotal,
              value: data.mtdTotal.formatRainfall(context, unit),
            ),
            const SizedBox(height: 8),
            _ComparisonRow(
              label: l10n.mtdBreakdown2yrAvg,
              currentValue: data.mtdTotal,
              comparisonValue: data.twoYrAvg,
              unit: unit,
            ),
            const SizedBox(height: 8),
            _ComparisonRow(
              label: l10n.mtdBreakdown5yrAvg,
              currentValue: data.mtdTotal,
              comparisonValue: data.fiveYrAvg,
              unit: unit,
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
      children: [
        Expanded(
          child: Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(value, style: textTheme.bodyMedium),
      ],
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  const _ComparisonRow({
    required this.label,
    required this.currentValue,
    required this.comparisonValue,
    required this.unit,
  });

  final String label;
  final double currentValue;
  final double comparisonValue;
  final MeasurementUnit unit;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ComparisonIcon(current: currentValue, comparison: comparisonValue),
            const SizedBox(width: 4),
            Text(
              comparisonValue.formatRainfall(context, unit),
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

  final double current;
  final double comparison;

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
