import "dart:math";

import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rain_wise/core/application/preferences_provider.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/seasonal_patterns/domain/seasonal_patterns_data.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/user_preferences.dart";
import "package:rain_wise/shared/widgets/charts/chart_card.dart";

class SeasonalTrendChart extends ConsumerWidget {
  const SeasonalTrendChart({required this.trendData, super.key});

  final List<SeasonalTrendPoint> trendData;

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

    return ChartCard(
      title: l10n.rainfallTrendsTitle,
      margin: EdgeInsets.zero,
      chart: LineChart(
        LineChartData(
          maxY: displayMaxRainfall > 0
              ? (displayMaxRainfall * 1.2).ceilToDouble()
              : 5.0,
          gridData: _buildGridData(Theme.of(context).colorScheme),
          titlesData: _buildTitlesData(Theme.of(context)),
          borderData: FlBorderData(show: false),
          lineTouchData: _buildLineTouchData(context, unit),
          lineBarsData: [_buildLineBarData(Theme.of(context), isInch)],
        ),
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

  FlTitlesData _buildTitlesData(final ThemeData theme) => FlTitlesData(
    topTitles: const AxisTitles(),
    rightTitles: const AxisTitles(),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        interval: (trendData.length / 4).floorToDouble().clamp(1.0, 30.0),
        getTitlesWidget: (final value, final meta) {
          if (value.toInt() >= trendData.length) {
            return const Text("");
          }
          final DateTime date = trendData[value.toInt()].date;
          return Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              DateFormat.MMM().format(date),
              style: theme.textTheme.bodySmall,
            ),
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
            style: theme.textTheme.bodySmall,
          );
        },
      ),
    ),
  );

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
