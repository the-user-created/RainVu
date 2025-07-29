import "dart:math";

import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:rain_wise/features/insights/domain/seasonal_patterns_data.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

class SeasonalTrendChart extends StatelessWidget {
  const SeasonalTrendChart({required this.trendData, super.key});

  final List<SeasonalTrendPoint> trendData;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    final double maxRainfall = trendData.isEmpty
        ? 10.0
        : trendData.map((final e) => e.rainfall).reduce(max);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Rainfall Trends", style: theme.titleMedium),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  maxY: (maxRainfall * 1.2).ceilToDouble(),
                  gridData: FlGridData(
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (final value) =>
                        FlLine(color: theme.alternate, strokeWidth: 1),
                  ),
                  titlesData: _buildTitlesData(theme),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [_buildLineBarData(theme)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FlTitlesData _buildTitlesData(final FlutterFlowTheme theme) => FlTitlesData(
        topTitles: const AxisTitles(),
        rightTitles: const AxisTitles(),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: (trendData.length / 4).floorToDouble(),
            getTitlesWidget: (final value, final meta) {
              if (value.toInt() >= trendData.length) {
                return const Text("");
              }
              final DateTime date = trendData[value.toInt()].date;
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child:
                    Text(DateFormat.MMM().format(date), style: theme.bodySmall),
              );
            },
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: true, reservedSize: 40),
        ),
      );

  LineChartBarData _buildLineBarData(final FlutterFlowTheme theme) =>
      LineChartBarData(
        spots: trendData
            .asMap()
            .entries
            .map(
              (final entry) =>
                  FlSpot(entry.key.toDouble(), entry.value.rainfall),
            )
            .toList(),
        isCurved: true,
        color: theme.primary,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [
              theme.primary.withValues(alpha: 0.3),
              theme.primary.withValues(alpha: 0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      );
}
