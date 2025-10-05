import "dart:math";

import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/application/preferences_provider.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/home/domain/home_data.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/user_preferences.dart";

class MonthlyTrendChart extends ConsumerWidget {
  const MonthlyTrendChart({required this.trends, super.key});

  final List<MonthlyTrendPoint> trends;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final MeasurementUnit unit =
        ref.watch(userPreferencesProvider).value?.measurementUnit ??
        MeasurementUnit.mm;
    final bool isInch = unit == MeasurementUnit.inch;

    final double maxRainfall = trends.isEmpty
        ? 1.0
        : trends.map((final e) => e.rainfall).reduce(max);
    final double displayMaxRainfall = isInch
        ? maxRainfall.toInches()
        : maxRainfall;

    return Card(
      elevation: 2,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.monthlyTrendChartTitle, style: textTheme.titleMedium),
                Text(
                  l10n.monthlyTrendChartSubtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  maxY: (displayMaxRainfall * 1.2).clamp(
                    isInch ? 0.5 : 10.0,
                    double.infinity,
                  ),
                  barTouchData: _buildBarTouchData(context, unit),
                  titlesData: _buildTitlesData(textTheme),
                  gridData: _buildGridData(colorScheme),
                  borderData: FlBorderData(show: false),
                  barGroups: _buildBarGroups(colorScheme, isInch),
                  alignment: BarChartAlignment.spaceAround,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarTouchData _buildBarTouchData(
    final BuildContext context,
    final MeasurementUnit unit,
  ) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final bool isInch = unit == MeasurementUnit.inch;

    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        getTooltipColor: (final group) => theme.colorScheme.primary,
        getTooltipItem:
            (final group, final groupIndex, final rod, final rodIndex) {
              final double mmValue = isInch ? rod.toY.toMillimeters() : rod.toY;
              final String formattedValue = mmValue.formatRainfall(
                context,
                unit,
              );
              final String month = trends[groupIndex].month;

              return BarTooltipItem(
                "$month\n",
                theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onPrimary,
                ),
                children: [
                  TextSpan(
                    text: l10n.rainfallAmountTooltip(formattedValue),
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              );
            },
      ),
    );
  }

  FlTitlesData _buildTitlesData(final TextTheme textTheme) => FlTitlesData(
    topTitles: const AxisTitles(),
    rightTitles: const AxisTitles(),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: (final value, final meta) {
          final int index = value.toInt();
          if (index >= trends.length) {
            return const Text("");
          }
          return Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(trends[index].month, style: textTheme.bodySmall),
          );
        },
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 40,
        getTitlesWidget: (final value, final meta) {
          if (value == meta.max || value == meta.min) {
            return const SizedBox();
          }
          return Text(
            value.round().toString(),
            style: textTheme.bodySmall,
            textAlign: TextAlign.left,
          );
        },
      ),
    ),
  );

  FlGridData _buildGridData(final ColorScheme colorScheme) => FlGridData(
    drawVerticalLine: false,
    getDrawingHorizontalLine: (final value) => FlLine(
      color: colorScheme.outline.withValues(alpha: 0.5),
      strokeWidth: 1,
    ),
  );

  List<BarChartGroupData> _buildBarGroups(
    final ColorScheme colorScheme,
    final bool isInch,
  ) => trends
      .asMap()
      .entries
      .map(
        (final entry) => BarChartGroupData(
          x: entry.key,
          barRods: [
            BarChartRodData(
              toY: isInch
                  ? entry.value.rainfall.toInches()
                  : entry.value.rainfall,
              color: colorScheme.secondary,
              width: 12,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(2),
                topRight: Radius.circular(2),
              ),
            ),
          ],
        ),
      )
      .toList();
}
