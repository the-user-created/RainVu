import "dart:math";

import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:rain_wise/features/insights/domain/monthly_breakdown_data.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

class DailyRainfallChart extends StatelessWidget {
  const DailyRainfallChart({required this.chartData, super.key});

  final List<DailyRainfallPoint> chartData;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    // Find the maximum rainfall value to set the chart's Y-axis limit.
    final double maxRainfall = chartData.isEmpty
        ? 10
        : chartData.map((final e) => e.rainfall).reduce(max);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Daily Rainfall", style: theme.titleMedium),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  // Set maxY for performance and visual padding.
                  maxY: (maxRainfall * 1.2).ceilToDouble(),
                  barTouchData: _buildBarTouchData(theme),
                  titlesData: _buildTitlesData(theme),
                  gridData: _buildGridData(theme),
                  borderData: FlBorderData(show: false),
                  barGroups: _buildBarGroups(theme),
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
  BarTouchData _buildBarTouchData(final FlutterFlowTheme theme) => BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (final group) => theme.secondaryText,
          // Display the rainfall amount with one decimal place in the tooltip.
          getTooltipItem:
              (final group, final groupIndex, final rod, final rodIndex) =>
                  BarTooltipItem(
            "${rod.toY.toStringAsFixed(1)} mm",
            TextStyle(
              color: theme.primaryBackground,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

  /// Configures the titles for the X and Y axes.
  FlTitlesData _buildTitlesData(final FlutterFlowTheme theme) => FlTitlesData(
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
                  child: Text(value.toInt().toString(), style: theme.bodySmall),
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
                style: theme.bodySmall,
                textAlign: TextAlign.left,
              );
            },
          ),
        ),
      );

  /// Configures the background grid of the chart.
  FlGridData _buildGridData(final FlutterFlowTheme theme) => FlGridData(
        drawVerticalLine: false, // Hide vertical lines for a cleaner look.
        // Draw subtle, dashed horizontal lines.
        getDrawingHorizontalLine: (final value) => FlLine(
          color: theme.alternate,
          strokeWidth: 1,
          dashArray: [5, 5],
        ),
      );

  /// Creates the list of bar groups from the provided chart data.
  List<BarChartGroupData> _buildBarGroups(final FlutterFlowTheme theme) =>
      chartData
          .map(
            (final data) => BarChartGroupData(
              x: data.day,
              barRods: [
                BarChartRodData(
                  toY: data.rainfall,
                  color: theme.primary,
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
