import "package:collection/collection.dart";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:rain_wise/features/insights/domain/comparative_analysis_data.dart";

class ComparativeAnalysisChart extends StatelessWidget {
  const ComparativeAnalysisChart({
    required this.chartData,
    super.key,
  });

  final ComparativeChartData chartData;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final List<Color> colors = [colorScheme.secondary, colorScheme.tertiary];

    if (chartData.series.isEmpty || chartData.series.first.data.isEmpty) {
      return const SizedBox(
        height: 300,
        child: Center(child: Text("Not enough data to display chart.")),
      );
    }

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
                  "Rainfall Comparison",
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
                  barGroups: _generateBarGroups(colors),
                  titlesData: _buildTitles(theme),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (final value) => FlLine(
                      color: colorScheme.outline,
                      strokeWidth: 1,
                    ),
                  ),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (final _) => colorScheme.primary,
                      getTooltipItem: (
                        final group,
                        final groupIndex,
                        final rod,
                        final rodIndex,
                      ) {
                        final int year = chartData.series[rodIndex].year;
                        return BarTooltipItem(
                          "$year\n",
                          TextStyle(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "${rod.toY.toStringAsFixed(1)} mm",
                              style: TextStyle(color: colorScheme.onPrimary),
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

  List<BarChartGroupData> _generateBarGroups(final List<Color> colors) {
    const double barWidth = 12;
    const double spaceBetween = 4;
    return List.generate(
      chartData.labels.length,
      (final i) => BarChartGroupData(
        x: i,
        barRods: chartData.series
            .mapIndexed(
              (final index, final series) => BarChartRodData(
                toY: series.data[i],
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
