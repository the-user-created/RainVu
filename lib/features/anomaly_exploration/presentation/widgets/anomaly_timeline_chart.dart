import "dart:math";

import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/anomaly_exploration/domain/anomaly_data.dart";
import "package:rain_wise/features/settings/application/preferences_provider.dart";
import "package:rain_wise/features/settings/domain/user_preferences.dart";
import "package:rain_wise/l10n/app_localizations.dart";

class AnomalyTimelineChart extends ConsumerWidget {
  const AnomalyTimelineChart({required this.chartPoints, super.key});

  final List<AnomalyChartPoint> chartPoints;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = AppLocalizations.of(context);
    final unit =
        ref.watch(userPreferencesNotifierProvider).value?.measurementUnit ??
            MeasurementUnit.mm;
    final isInch = unit == MeasurementUnit.inch;

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
                      color: colorScheme.secondary,
                      text: l10n.anomalyTimelineLegendActual,
                    ),
                    const SizedBox(width: 8),
                    _LegendItem(
                      color: colorScheme.tertiary,
                      text: l10n.anomalyTimelineLegendAverage,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 240,
              child: chartPoints.isEmpty
                  ? Center(
                      child: Text(
                        l10n.anomalyTimelineChartPlaceholder,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : _buildChart(context, isInch),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(final BuildContext context, final bool isInch) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final double maxRainfall = chartPoints.isEmpty
        ? 10
        : chartPoints
            .map((final p) => max(p.actualRainfall, p.averageRainfall))
            .reduce(max);
    final double displayMaxRainfall =
        isInch ? maxRainfall.toInches() : maxRainfall;

    final List<FlSpot> averageSpots = [];
    final List<FlSpot> actualSpots = [];
    for (int i = 0; i < chartPoints.length; i++) {
      final AnomalyChartPoint point = chartPoints[i];
      averageSpots.add(
        FlSpot(
          i.toDouble(),
          isInch ? point.averageRainfall.toInches() : point.averageRainfall,
        ),
      );
      actualSpots.add(
        FlSpot(
          i.toDouble(),
          isInch ? point.actualRainfall.toInches() : point.actualRainfall,
        ),
      );
    }

    return LineChart(
      LineChartData(
        maxY: (displayMaxRainfall * 1.2).clamp(10, double.infinity),
        gridData: FlGridData(
          drawVerticalLine: false,
          getDrawingHorizontalLine: (final value) => FlLine(
            color: colorScheme.outline.withValues(alpha: 0.5),
            strokeWidth: 1,
            dashArray: [4, 4],
          ),
        ),
        titlesData: const FlTitlesData(
          leftTitles: AxisTitles(),
          topTitles: AxisTitles(),
          rightTitles: AxisTitles(),
          bottomTitles: AxisTitles(),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          // Average rainfall line
          LineChartBarData(
            spots: averageSpots,
            isCurved: true,
            color: colorScheme.tertiary,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(),
          ),
          // Actual rainfall line
          LineChartBarData(
            spots: actualSpots,
            isCurved: true,
            color: colorScheme.secondary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: colorScheme.secondary.withValues(alpha: 0.2),
            ),
          ),
        ],
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
