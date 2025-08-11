import "dart:math";

import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:rain_wise/features/monthly_breakdown/domain/monthly_breakdown_data.dart";
import "package:rain_wise/l10n/app_localizations.dart";

class DailyRainfallChart extends StatelessWidget {
  const DailyRainfallChart({required this.chartData, super.key});

  final List<DailyRainfallPoint> chartData;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    // Find the maximum rainfall value to set the chart's Y-axis limit.
    final double maxRainfall = chartData.isEmpty
        ? 10
        : chartData.map((final e) => e.rainfall).reduce(max);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.dailyRainfallChartTitle, style: textTheme.titleMedium),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  // Set maxY for performance and visual padding.
                  maxY: (maxRainfall * 1.2).ceilToDouble(),
                  barTouchData:
                      _buildBarTouchData(l10n, colorScheme, textTheme),
                  titlesData: _buildTitlesData(textTheme),
                  gridData: _buildGridData(colorScheme),
                  borderData: FlBorderData(show: false),
                  barGroups: _buildBarGroups(colorScheme),
                  alignment: BarChartAlignment.spaceAround,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Configures the interactive tooltip for the bar chart.
  BarTouchData _buildBarTouchData(
    final AppLocalizations l10n,
    final ColorScheme colorScheme,
    final TextTheme textTheme,
  ) =>
      BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (final group) => colorScheme.onSurfaceVariant,
          getTooltipItem:
              (final group, final groupIndex, final rod, final rodIndex) =>
                  BarTooltipItem(
            l10n.dailyRainfallChartTooltip(rod.toY.toStringAsFixed(1)),
            textTheme.bodySmall!.copyWith(
              color: colorScheme.surface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

  /// Configures the titles for the X and Y axes.
  FlTitlesData _buildTitlesData(final TextTheme textTheme) => FlTitlesData(
        topTitles: const AxisTitles(),
        rightTitles: const AxisTitles(),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (final value, final meta) {
              // Show title for every 5th day to avoid clutter.
              if (value.toInt() % 5 == 0 && value.toInt() != 0) {
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    value.toInt().toString(),
                    style: textTheme.bodySmall,
                  ),
                );
              }
              return const Text("");
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (final value, final meta) {
              // Avoid drawing labels at the very top and bottom of the axis.
              if (value == meta.max || value == 0) {
                return const Text("");
              }
              return Text(
                value.toInt().toString(),
                style: textTheme.bodySmall,
                textAlign: TextAlign.left,
              );
            },
          ),
        ),
      );

  /// Configures the background grid of the chart.
  FlGridData _buildGridData(final ColorScheme colorScheme) => FlGridData(
        drawVerticalLine: false,
        getDrawingHorizontalLine: (final value) => FlLine(
          color: colorScheme.outline,
          strokeWidth: 1,
          dashArray: [5, 5],
        ),
      );

  /// Creates the list of bar groups from the provided chart data.
  List<BarChartGroupData> _buildBarGroups(final ColorScheme colorScheme) =>
      chartData
          .map(
            (final data) => BarChartGroupData(
              x: data.day,
              barRods: [
                BarChartRodData(
                  toY: data.rainfall,
                  color: colorScheme.secondary,
                  width: 7,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
              ],
            ),
          )
          .toList();
}
