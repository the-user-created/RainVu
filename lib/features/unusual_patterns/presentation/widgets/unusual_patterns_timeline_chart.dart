import "dart:math";
import "dart:ui" as ui;

import "package:collection/collection.dart";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rain_wise/core/application/preferences_provider.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/unusual_patterns/domain/unusual_patterns_data.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/user_preferences.dart";
import "package:rain_wise/shared/widgets/charts/chart_card.dart";
import "package:rain_wise/shared/widgets/charts/legend_item.dart";

typedef _ChartDataPoint = ({
  DateTime date,
  double actualRainfall,
  double averageRainfall,
});

class AnomalyTimelineChart extends ConsumerWidget {
  const AnomalyTimelineChart({
    required this.chartPoints,
    required this.dateRange,
    super.key,
  });

  final List<AnomalyChartPoint> chartPoints;
  final DateTimeRange dateRange;

  /// Base minimum width for each data point
  static const double _baseMinPointWidth = 35;

  /// Prepares chart data by either using daily points or aggregating them monthly.
  List<_ChartDataPoint> _prepareData(
    final List<AnomalyChartPoint> points,
    final bool isMultiYear,
  ) {
    if (isMultiYear) {
      // Group by year and month, then sum up values for each month.
      final Map<DateTime, List<AnomalyChartPoint>> monthlyData = groupBy(
        points,
        (final p) => DateTime(p.date.year, p.date.month),
      );

      final List<_ChartDataPoint> aggregatedPoints =
          monthlyData.entries.map((final entry) {
              final DateTime date = entry.key;
              final List<AnomalyChartPoint> dailyPoints = entry.value;

              final double totalActual = dailyPoints
                  .map((final p) => p.actualRainfall)
                  .sum;
              final double totalAverage = dailyPoints
                  .map((final p) => p.averageRainfall)
                  .sum;

              return (
                date: date,
                actualRainfall: totalActual,
                averageRainfall: totalAverage,
              );
            }).toList()
            // Sort by date as groupBy doesn't guarantee order.
            ..sort((final a, final b) => a.date.compareTo(b.date));
      return aggregatedPoints;
    } else {
      // Use daily data as is for single-year ranges.
      return points
          .map(
            (final p) => (
              date: p.date,
              actualRainfall: p.actualRainfall,
              averageRainfall: p.averageRainfall,
            ),
          )
          .toList();
    }
  }

  /// Calculate the width of the widest label to determine minimum point width
  double _calculateMinPointWidth(
    final BuildContext context,
    final TextScaler textScaler,
    final List<_ChartDataPoint> processedPoints,
    final bool isMultiYear,
  ) {
    final TextStyle labelStyle =
        Theme.of(context).textTheme.bodySmall ?? const TextStyle();

    double maxLabelWidth = 0;

    for (final point in processedPoints) {
      final String label = isMultiYear
          ? DateFormat("MMM yy").format(point.date)
          : DateFormat("dd MMM").format(point.date);

      final TextPainter textPainter = TextPainter(
        text: TextSpan(text: label, style: labelStyle),
        textDirection: ui.TextDirection.ltr,
        textScaler: textScaler,
      )..layout();

      maxLabelWidth = max(maxLabelWidth, textPainter.width);
    }

    // Add padding between labels (20% of label width, minimum 16px)
    final double padding = max(maxLabelWidth * 0.2, 16.0);

    // Ensure minimum width accounts for the label plus padding
    return max(_baseMinPointWidth, maxLabelWidth + padding);
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = AppLocalizations.of(context);
    final MeasurementUnit unit =
        ref.watch(userPreferencesProvider).value?.measurementUnit ??
        MeasurementUnit.mm;
    final bool isInch = unit == MeasurementUnit.inch;
    final TextScaler textScaler = MediaQuery.textScalerOf(context);

    final bool isMultiYear = dateRange.start.year != dateRange.end.year;

    final List<_ChartDataPoint> processedPoints = _prepareData(
      chartPoints,
      isMultiYear,
    );

    return ChartCard(
      title: l10n.rainfallTrendsTitle,
      legend: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          LegendItem(
            color: colorScheme.secondary,
            text: l10n.anomalyTimelineLegendActual,
            shape: LegendShape.circle,
          ),
          LegendItem(
            color: colorScheme.tertiary,
            text: l10n.anomalyTimelineLegendAverage,
            shape: LegendShape.circle,
          ),
        ],
      ),
      chart: processedPoints.isEmpty
          ? SizedBox(
              height: 240,
              child: Center(
                child: Text(
                  l10n.noDataToSetDateRange,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
          : LayoutBuilder(
              builder: (final context, final constraints) {
                // Calculate dynamic minimum point width based on label sizes
                final double minPointWidth = _calculateMinPointWidth(
                  context,
                  textScaler,
                  processedPoints,
                  isMultiYear,
                );

                final double calculatedWidth =
                    processedPoints.length * minPointWidth;
                final double chartWidth = max(
                  constraints.maxWidth,
                  calculatedWidth,
                );

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: SizedBox(
                    width: chartWidth,
                    height: 240,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16, top: 16),
                      child: _buildChart(
                        context,
                        l10n: l10n,
                        unit: unit,
                        isInch: isInch,
                        isMultiYear: isMultiYear,
                        processedPoints: processedPoints,
                        availableWidth: chartWidth,
                        textScaler: textScaler,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildChart(
    final BuildContext context, {
    required final AppLocalizations l10n,
    required final MeasurementUnit unit,
    required final bool isInch,
    required final bool isMultiYear,
    required final List<_ChartDataPoint> processedPoints,
    required final double availableWidth,
    required final TextScaler textScaler,
  }) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    final double maxRainfall = processedPoints.isEmpty
        ? 10
        : processedPoints
              .map((final p) => max(p.actualRainfall, p.averageRainfall))
              .reduce(max);
    final double displayMaxRainfall = isInch
        ? maxRainfall.toInches()
        : maxRainfall;

    final List<FlSpot> averageSpots = [];
    final List<FlSpot> actualSpots = [];
    for (int i = 0; i < processedPoints.length; i++) {
      final _ChartDataPoint point = processedPoints[i];
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
        maxY: (displayMaxRainfall * 1.2).clamp(
          isInch ? 0.5 : 10,
          double.infinity,
        ),
        gridData: FlGridData(
          getDrawingHorizontalLine: (final value) => FlLine(
            color: colorScheme.outline.withValues(alpha: 0.5),
            strokeWidth: 1,
            dashArray: [4, 4],
          ),
          getDrawingVerticalLine: (final value) => FlLine(
            color: colorScheme.outline.withValues(alpha: 0.5),
            strokeWidth: 1,
            dashArray: [4, 4],
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40 * textScaler.scale(1),
              getTitlesWidget: (final value, final meta) {
                if (value == meta.max || value == meta.min) {
                  return const SizedBox();
                }
                final String text = isInch
                    ? value.toStringAsFixed(1)
                    : value.round().toString();
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    text,
                    style: textTheme.bodySmall,
                    textAlign: TextAlign.right,
                    maxLines: 1,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 20 * textScaler.scale(1),
              interval: (processedPoints.length / (availableWidth / 120))
                  .ceil()
                  .toDouble()
                  .clamp(1.0, double.infinity),
              getTitlesWidget: (final value, final meta) {
                final int index = value.toInt();
                if (index < 0 || index >= processedPoints.length) {
                  return const SizedBox();
                }
                final DateTime date = processedPoints[index].date;
                final String label = isMultiYear
                    ? DateFormat("MMM yy").format(date)
                    : DateFormat("dd MMM").format(date);

                return SideTitleWidget(
                  meta: meta,
                  fitInside: SideTitleFitInsideData.fromTitleMeta(
                    meta,
                    distanceFromEdge: 0,
                  ),
                  child: Text(label, style: textTheme.bodySmall),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
        ),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            fitInsideHorizontally: true,
            getTooltipColor: (final spot) =>
                colorScheme.surfaceContainerHighest,
            tooltipBorder: BorderSide(
              color: colorScheme.outline.withValues(alpha: 0.5),
            ),
            getTooltipItems: (final touchedSpots) {
              if (touchedSpots.isEmpty) {
                return [];
              }

              final int index = touchedSpots.first.spotIndex;
              if (index < 0 || index >= processedPoints.length) {
                return [];
              }

              final _ChartDataPoint point = processedPoints[index];
              final String dateText = isMultiYear
                  ? DateFormat.yMMM().format(point.date)
                  : DateFormat.yMMMd().format(point.date);

              final String actualValue = point.actualRainfall.formatRainfall(
                context,
                unit,
              );
              final String averageValue = point.averageRainfall.formatRainfall(
                context,
                unit,
              );

              return touchedSpots.map((final spot) {
                if (spot.barIndex == 0) {
                  // Show full tooltip only for first line
                  return LineTooltipItem(
                    "$dateText\n",
                    textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    children: [
                      TextSpan(
                        text: "${l10n.anomalyTimelineLegendActual}: ",
                        style: textTheme.bodySmall!.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: "$actualValue\n",
                        style: textTheme.bodySmall!.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      TextSpan(
                        text: "${l10n.anomalyTimelineLegendAverage}: ",
                        style: textTheme.bodySmall!.copyWith(
                          color: colorScheme.tertiary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: averageValue,
                        style: textTheme.bodySmall!.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  );
                } else {
                  return null;
                }
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          // Average rainfall line
          LineChartBarData(
            preventCurveOverShooting: true,
            spots: averageSpots,
            isCurved: true,
            color: colorScheme.tertiary,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(),
          ),
          // Actual rainfall line
          LineChartBarData(
            preventCurveOverShooting: true,
            spots: actualSpots,
            isCurved: true,
            color: colorScheme.secondary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  colorScheme.secondary.withValues(alpha: 0.3),
                  colorScheme.secondary.withValues(alpha: 0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
