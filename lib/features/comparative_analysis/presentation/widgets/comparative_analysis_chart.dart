import "package:collection/collection.dart";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/application/preferences_provider.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/comparative_analysis/domain/comparative_analysis_data.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/user_preferences.dart";

class ComparativeAnalysisChart extends ConsumerWidget {
  const ComparativeAnalysisChart({required this.chartData, super.key});

  final ComparativeChartData chartData;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
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

    // TODO: The chart gets very cramped on monthly view on tighter screens (there is 0 gap between bars for different months). Consider making the chart horizontally scrollable if there are too many groups.

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.comparativeAnalysisChartTitle,
                  style: textTheme.titleMedium,
                ),
                Row(
                  children: chartData.series
                      .mapIndexed(
                        (final index, final series) => _Legend(
                          color: colors[index % colors.length],
                          text: series.year.toString(),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: isSingleGroup
                      ? BarChartAlignment.center
                      : BarChartAlignment.spaceBetween,
                  barGroups: _generateBarGroups(colors, isInch),
                  titlesData: _buildTitles(theme),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (final value) =>
                        FlLine(color: colorScheme.outline, strokeWidth: 1),
                  ),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      fitInsideHorizontally: true,
                      getTooltipColor: (final _) => colorScheme.primary,
                      getTooltipItem:
                          (
                            final group,
                            final groupIndex,
                            final rod,
                            final rodIndex,
                          ) {
                            final int year = chartData.series[rodIndex].year;
                            final String label = chartData.labels[groupIndex];
                            final String titleText = isSingleGroup
                                ? "$year\n"
                                : "$year $label\n";

                            // Rod value is already in the display unit. Convert it
                            // back to mm for consistent formatting logic.
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
                                  style: TextStyle(
                                    color: colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            );
                          },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FlTitlesData _buildTitles(final ThemeData theme) => FlTitlesData(
    rightTitles: const AxisTitles(),
    topTitles: const AxisTitles(),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: (final value, final meta) {
          final int index = value.toInt();
          if (index < chartData.labels.length) {
            return Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                chartData.labels[index],
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

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.text});

  final Color color;
  final String text;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 4),
          Text(text, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
