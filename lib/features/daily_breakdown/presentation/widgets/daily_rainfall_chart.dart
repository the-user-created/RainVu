import "dart:math";

import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rainvu/core/application/preferences_provider.dart";
import "package:rainvu/core/utils/extensions.dart";
import "package:rainvu/features/daily_breakdown/domain/daily_breakdown_data.dart";
import "package:rainvu/l10n/app_localizations.dart";
import "package:rainvu/shared/domain/user_preferences.dart";
import "package:rainvu/shared/utils/chart_semantics_helper.dart";
import "package:rainvu/shared/widgets/charts/chart_card.dart";
import "package:rainvu/shared/widgets/charts/legend_item.dart";

class DailyRainfallChart extends ConsumerWidget {
  const DailyRainfallChart({required this.chartData, super.key});

  final List<DailyRainfallPoint> chartData;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final MeasurementUnit unit =
        ref.watch(userPreferencesProvider).value?.measurementUnit ??
        MeasurementUnit.mm;
    final bool isInch = unit == MeasurementUnit.inch;

    final double maxRainfall = chartData.isEmpty
        ? 10
        : chartData.map((final e) => e.rainfall).reduce(max);
    final double displayMaxRainfall = isInch
        ? maxRainfall.toInches()
        : maxRainfall;

    final barChart = BarChart(
      BarChartData(
        maxY: (displayMaxRainfall * 1.2).clamp(
          isInch ? 0.5 : 10.0,
          double.infinity,
        ),
        barTouchData: _buildBarTouchData(context, unit),
        titlesData: _buildTitlesData(theme.textTheme),
        gridData: _buildGridData(colorScheme),
        borderData: FlBorderData(show: false),
        barGroups: _buildBarGroups(colorScheme, isInch),
        alignment: BarChartAlignment.spaceAround,
      ),
    );

    final String semanticLabel = ChartSemanticsHelper.getBarChartDescription(
      context: context,
      title: l10n.dailyRainfallChartTitle,
      dataPoints: ChartSemanticsHelper.fromDailyRainfallPoints(chartData, l10n),
      unit: unit,
    );

    return Semantics(
      label: l10n.dailyRainfallChartTitle,
      value: semanticLabel,
      child: ChartCard(
        title: l10n.dailyRainfallChartTitle,
        margin: EdgeInsets.zero,
        legend: LegendItem(
          color: colorScheme.secondary,
          text: l10n.legendDailyRainfall,
        ),
        chart: LayoutBuilder(
          builder: (final context, final constraints) {
            const double minPointWidth = 18;
            final double calculatedWidth = chartData.length * minPointWidth;
            final double chartWidth = max(
              constraints.maxWidth,
              calculatedWidth,
            );

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: SizedBox(width: chartWidth, height: 200, child: barChart),
            );
          },
        ),
      ),
    );
  }

  /// Configures the interactive tooltip for the bar chart.
  BarTouchData _buildBarTouchData(
    final BuildContext context,
    final MeasurementUnit unit,
  ) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final bool isInch = unit == MeasurementUnit.inch;

    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        fitInsideHorizontally: true,
        getTooltipColor: (final group) => theme.colorScheme.primary,
        getTooltipItem:
            (final group, final groupIndex, final rod, final rodIndex) {
              final double mmValue = isInch ? rod.toY.toMillimeters() : rod.toY;
              final String formattedValue = mmValue.formatRainfall(
                context,
                unit,
              );

              return BarTooltipItem(
                l10n.rainfallAmountTooltip(formattedValue),
                theme.textTheme.bodySmall!.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
      ),
    );
  }

  /// Configures the titles for the X and Y axes.
  FlTitlesData _buildTitlesData(final TextTheme textTheme) => FlTitlesData(
    topTitles: const AxisTitles(),
    rightTitles: const AxisTitles(),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 40,
        getTitlesWidget: (final value, final meta) {
          final int day = value.toInt();
          // Show labels for day 1, and every 5 days after.
          if (day > 0 && (day == 1 || day % 5 == 0)) {
            return Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(day.toString(), style: textTheme.bodySmall),
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
      color: colorScheme.outline.withValues(alpha: 0.5),
      strokeWidth: 1,
    ),
  );

  /// Creates the list of bar groups from the provided chart data.
  List<BarChartGroupData> _buildBarGroups(
    final ColorScheme colorScheme,
    final bool isInch,
  ) => chartData
      .map(
        (final data) => BarChartGroupData(
          x: data.day,
          barRods: [
            BarChartRodData(
              toY: isInch ? data.rainfall.toInches() : data.rainfall,
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
