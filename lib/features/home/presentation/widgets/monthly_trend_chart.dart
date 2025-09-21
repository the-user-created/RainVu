import "dart:math";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/home/domain/home_data.dart";
import "package:rain_wise/features/settings/application/preferences_provider.dart";
import "package:rain_wise/features/settings/domain/user_preferences.dart";
import "package:rain_wise/l10n/app_localizations.dart";

class MonthlyTrendChart extends StatelessWidget {
  const MonthlyTrendChart({required this.trends, super.key});

  final List<MonthlyTrendPoint> trends;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    const double chartContainerHeight = 200;
    const double chartContainerVPadding = 32;
    const double labelAreaHeight = 24;
    const double valueLabelHeight = 16;
    const double maxChartHeight =
        chartContainerHeight -
        chartContainerVPadding -
        labelAreaHeight -
        valueLabelHeight;

    final double maxRainfall = trends.isEmpty
        ? 1.0
        : trends.map((final e) => e.rainfall).reduce(max);

    return Card(
      elevation: 2,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.monthlyTrendChartTitle,
                  style: textTheme.headlineSmall,
                ),
                Text(
                  l10n.monthlyTrendChartSubtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: chartContainerHeight,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outline),
              ),
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: trends.map((final point) {
                  final double normalizedHeight = maxRainfall > 0
                      ? (point.rainfall / maxRainfall) * maxChartHeight
                      : 0.0;
                  return Expanded(
                    child: _ChartBar(
                      label: point.month,
                      value: point.rainfall,
                      height: normalizedHeight.clamp(5.0, maxChartHeight),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartBar extends ConsumerWidget {
  const _ChartBar({
    required this.label,
    required this.height,
    required this.value,
  });

  final String label;
  final double height;
  final double value;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final MeasurementUnit unit =
        ref.watch(userPreferencesProvider).value?.measurementUnit ??
        MeasurementUnit.mm;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          value.formatRainfall(context, unit, precision: 0, withUnit: false),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        FractionallySizedBox(
          widthFactor: 0.7,
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall,
          maxLines: 1,
          overflow: TextOverflow.clip,
        ),
      ],
    );
  }
}
