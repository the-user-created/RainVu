import "package:collection/collection.dart";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/application/preferences_provider.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/comparative_analysis/domain/comparative_analysis_data.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/user_preferences.dart";
import "package:rain_wise/shared/widgets/charts/chart_card.dart";
import "package:rain_wise/shared/widgets/charts/legend_item.dart";

class ComparativeAnalysisChart extends ConsumerWidget {
  const ComparativeAnalysisChart({required this.chartData, super.key});

  final ComparativeChartData chartData;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final List<Color> colors = [colorScheme.secondary, colorScheme.tertiary];
    final MeasurementUnit unit =
        ref.watch(userPreferencesProvider).value?.measurementUnit ??
        MeasurementUnit.mm;
    final bool isInch = unit == MeasurementUnit.inch;
    final bool isSingleGroup = chartData.labels.length == 1;

    if (chartData.series.isEmpty || chartData.series.first.data.isEmpty) {
      return SizedBox(
        height: 300,
        child: Center(child: Text(l10n.comparativeAnalysisChartNoData)),
      );
    }

    return ChartCard(
      title: l10n.comparativeAnalysisChartTitle,
      margin: const EdgeInsets.all(16),
      legend: Row(
        children: chartData.series
            .mapIndexed(
              (final index, final series) => LegendItem(
                color: colors[index % colors.length],
                text: series.year.toString(),
              ),
            )
            .toList(),
      ),
      chart: BarChart(
        BarChartData(
          alignment: isSingleGroup
              ? BarChartAlignment.center
              : BarChartAlignment.spaceBetween,
          barGroups: _generateBarGroups(colors, isInch),
          titlesData: _buildTitles(theme, l10n, isSingleGroup),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            drawVerticalLine: false,
            getDrawingHorizontalLine: (final value) => FlLine(
              color: colorScheme.outline.withValues(alpha: 0.5),
              strokeWidth: 1,
            ),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              fitInsideHorizontally: true,
              getTooltipColor: (final _) => colorScheme.primary,
              getTooltipItem:
                  (final group, final groupIndex, final rod, final rodIndex) {
                    final int year = chartData.series[rodIndex].year;
                    final String label = isSingleGroup
                        ? l10n.totalLabel
                        : chartData.labels[groupIndex];
                    final String titleText = isSingleGroup
                        ? "$year\n"
                        : "$year $label\n";

                    final double mmValue = isInch
                        ? rod.toY.toMillimeters()
                        : rod.toY;

                    return BarTooltipItem(
                      titleText,
                      TextStyle(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: mmValue.formatRainfall(context, unit),
                          style: TextStyle(color: colorScheme.onPrimary),
                        ),
                      ],
                    );
                  },
            ),
          ),
        ),
      ),
    );
  }

  FlTitlesData _buildTitles(
    final ThemeData theme,
    final AppLocalizations l10n,
    final bool isSingleGroup,
  ) => FlTitlesData(
    rightTitles: const AxisTitles(),
    topTitles: const AxisTitles(),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: (final value, final meta) {
          final int index = value.toInt();
          if (index < chartData.labels.length) {
            final String label = isSingleGroup
                ? l10n.totalLabel
                : chartData.labels[index];
            return Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(label, style: theme.textTheme.bodySmall),
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
          if (value == 0) {
            return const Text("");
          }
          if (value == meta.max) {
            return const Text("");
          }
          return Text(
            value.toInt().toString(),
            style: theme.textTheme.bodySmall,
          );
        },
      ),
    ),
  );

  List<BarChartGroupData> _generateBarGroups(
    final List<Color> colors,
    final bool isInch,
  ) {
    final double barWidth = chartData.labels.length == 1 ? 24 : 12;
    const double spaceBetween = 0;

    return List.generate(
      chartData.labels.length,
      (final i) => BarChartGroupData(
        x: i,
        barRods: chartData.series
            .mapIndexed(
              (final index, final series) => BarChartRodData(
                toY: isInch ? series.data[i].toInches() : series.data[i],
                color: colors[index % colors.length],
                width: barWidth,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(2),
                  topRight: Radius.circular(2),
                ),
              ),
            )
            .toList(),
        barsSpace: spaceBetween,
      ),
    );
  }
}
