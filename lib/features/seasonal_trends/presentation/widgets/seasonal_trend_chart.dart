import "dart:math";

import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rainvu/core/application/preferences_provider.dart";
import "package:rainvu/core/utils/extensions.dart";
import "package:rainvu/features/seasonal_trends/domain/seasonal_trends_data.dart";
import "package:rainvu/l10n/app_localizations.dart";
import "package:rainvu/shared/domain/user_preferences.dart";
import "package:rainvu/shared/widgets/charts/chart_card.dart";

class SeasonalTrendChart extends ConsumerWidget {
  const SeasonalTrendChart({required this.trendData, super.key});

  final List<SeasonalTrendPoint> trendData;

  /// Generates a map of titles for the bottom axis.
  ///
  /// Keys are the indices in the data where a new month starts,
  /// and values are the formatted month names (e.g., "Jan").
  /// This prevents duplicate month labels on the axis.
  Map<int, String> _getMonthTitles(final List<SeasonalTrendPoint> trendData) {
    if (trendData.isEmpty) {
      return {};
    }
    final Map<int, String> titles = {};
    int? lastMonth;

    for (int i = 0; i < trendData.length; i++) {
      final int currentMonth = trendData[i].date.month;
      if (lastMonth == null || currentMonth != lastMonth) {
        titles[i] = DateFormat.MMM().format(trendData[i].date);
        lastMonth = currentMonth;
      }
    }
    return titles;
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final MeasurementUnit unit =
        ref.watch(userPreferencesProvider).value?.measurementUnit ??
        MeasurementUnit.mm;
    final bool isInch = unit == MeasurementUnit.inch;

    final double maxRainfall = trendData.isEmpty
        ? 0.0
        : trendData.map((final e) => e.rainfall).reduce(max);
    final double displayMaxRainfall = isInch
        ? maxRainfall.toInches()
        : maxRainfall;

    final lineChart = LineChart(
      LineChartData(
        clipData: const FlClipData.all(),
        maxY: displayMaxRainfall > 0
            ? (displayMaxRainfall * 1.2).ceilToDouble()
            : 5.0,
        gridData: _buildGridData(Theme.of(context).colorScheme),
        titlesData: _buildTitlesData(Theme.of(context)),
        borderData: FlBorderData(show: false),
        lineTouchData: _buildLineTouchData(context, unit),
        lineBarsData: [_buildLineBarData(Theme.of(context), isInch)],
      ),
    );

    return ChartCard(
      title: l10n.rainfallTrendsTitle,
      margin: EdgeInsets.zero,
      chart: LayoutBuilder(
        builder: (final context, final constraints) {
          const double minPointWidth = 4;
          final double calculatedWidth = trendData.length * minPointWidth;
          final double chartWidth = max(constraints.maxWidth, calculatedWidth);

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: SizedBox(width: chartWidth, height: 250, child: lineChart),
          );
        },
      ),
    );
  }

  FlGridData _buildGridData(final ColorScheme colorScheme) => FlGridData(
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
  );

  LineTouchData _buildLineTouchData(
    final BuildContext context,
    final MeasurementUnit unit,
  ) {
    final ThemeData theme = Theme.of(context);
    return LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        fitInsideHorizontally: true,
        getTooltipColor: (final spot) =>
            theme.colorScheme.surfaceContainerHighest,
        tooltipBorder: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.5),
        ),
        getTooltipItems: (final touchedSpots) => touchedSpots.map((final spot) {
          final int index = spot.spotIndex;
          if (index < 0 || index >= trendData.length) {
            return null;
          }
          final SeasonalTrendPoint point = trendData[index];
          final String dateText = DateFormat.yMMMd().format(point.date);
          final String valueText = point.rainfall.formatRainfall(context, unit);

          return LineTooltipItem(
            "$dateText\n",
            theme.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            children: [
              TextSpan(
                text: valueText,
                style: theme.textTheme.bodySmall!.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  FlTitlesData _buildTitlesData(final ThemeData theme) {
    final Map<int, String> monthTitles = _getMonthTitles(trendData);
    return FlTitlesData(
      topTitles: const AxisTitles(),
      rightTitles: const AxisTitles(),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          interval: 1,
          getTitlesWidget: (final value, final meta) {
            final int index = value.toInt();
            if (monthTitles.containsKey(index)) {
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  monthTitles[index]!,
                  style: theme.textTheme.bodySmall,
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
            if (value == meta.max || value == meta.min) {
              return const SizedBox();
            }
            return Text(
              value.round().toString(),
              style: theme.textTheme.bodySmall,
            );
          },
        ),
      ),
    );
  }

  LineChartBarData _buildLineBarData(
    final ThemeData theme,
    final bool isInch,
  ) => LineChartBarData(
    spots: trendData
        .asMap()
        .entries
        .map(
          (final entry) => FlSpot(
            entry.key.toDouble(),
            isInch ? entry.value.rainfall.toInches() : entry.value.rainfall,
          ),
        )
        .toList(),
    isCurved: true,
    preventCurveOverShooting: true,
    color: theme.colorScheme.secondary,
    barWidth: 3,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(
      show: true,
      gradient: LinearGradient(
        colors: [
          theme.colorScheme.secondary.withValues(alpha: 0.3),
          theme.colorScheme.secondary.withValues(alpha: 0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
  );
}
