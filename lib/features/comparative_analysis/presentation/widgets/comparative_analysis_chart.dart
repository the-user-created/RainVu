import "dart:math";

import "package:collection/collection.dart";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/application/preferences_provider.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/comparative_analysis/domain/comparative_analysis_data.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/user_preferences.dart";
import "package:rain_wise/shared/widgets/charts/chart_card.dart";
import "package:rain_wise/shared/widgets/charts/legend_item.dart";

class ComparativeAnalysisChart extends ConsumerStatefulWidget {
  const ComparativeAnalysisChart({required this.chartData, super.key});

  final ComparativeChartData chartData;

  @override
  ConsumerState<ComparativeAnalysisChart> createState() =>
      _ComparativeAnalysisChartState();
}

class _ComparativeAnalysisChartState
    extends ConsumerState<ComparativeAnalysisChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  /// Minimum width for each bar group in a monthly/seasonal chart to ensure
  /// readability when scrolling.
  static const double _minBarGroupWidth = 48;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: 600.ms);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant final ComparativeAnalysisChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.chartData != oldWidget.chartData) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final List<Color> colors = [colorScheme.secondary, colorScheme.tertiary];
    final MeasurementUnit unit =
        ref.watch(userPreferencesProvider).value?.measurementUnit ??
        MeasurementUnit.mm;
    final bool isInch = unit == MeasurementUnit.inch;
    final bool isSingleGroup = widget.chartData.labels.length == 1;

    // Enable horizontal scrolling for charts with many labels (e.g., monthly view)
    final bool isScrollable = widget.chartData.labels.length > 8;

    if (widget.chartData.series.isEmpty ||
        widget.chartData.series.first.data.isEmpty) {
      return SizedBox(
        height: 300,
        child: Center(child: Text(l10n.comparativeAnalysisChartNoData)),
      );
    }

    // Calculate final maxY based on full data to keep the Y-axis static during animation
    final double maxDataValue = widget.chartData.series
        .expand((final series) => series.data)
        .reduce(max);
    final double displayMaxDataValue = isInch
        ? maxDataValue.toInches()
        : maxDataValue;
    final double finalMaxY = (displayMaxDataValue * 1.2).clamp(
      isInch ? 0.5 : 10.0,
      double.infinity,
    );

    return AnimatedBuilder(
      animation: _animation,
      builder: (final context, final child) {
        final barChart = BarChart(
          BarChartData(
            maxY: finalMaxY,
            alignment: isSingleGroup
                ? BarChartAlignment.center
                : BarChartAlignment.spaceBetween,
            barGroups: _generateBarGroups(colors, isInch, _animation.value),
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
                      // Tooltip should show the final value, not the animated one.
                      final double originalValue = isInch
                          ? widget.chartData.series[rodIndex].data[groupIndex]
                                .toInches()
                          : widget.chartData.series[rodIndex].data[groupIndex];

                      final int year = widget.chartData.series[rodIndex].year;
                      final String label = isSingleGroup
                          ? l10n.totalLabel
                          : widget.chartData.labels[groupIndex];
                      final String titleText = isSingleGroup
                          ? "$year\n"
                          : "$year $label\n";

                      final double mmValue = isInch
                          ? originalValue.toMillimeters()
                          : originalValue;

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
        );

        return ChartCard(
          title: l10n.comparativeAnalysisChartTitle,
          margin: const EdgeInsets.all(16),
          legend: Row(
            mainAxisSize: MainAxisSize.min,
            children: widget.chartData.series
                .mapIndexed(
                  (final index, final series) => Flexible(
                    child: LegendItem(
                      color: colors[index % colors.length],
                      text: series.year.toString(),
                    ),
                  ),
                )
                .toList(),
          ),
          chart: isScrollable
              ? LayoutBuilder(
                  builder: (final context, final constraints) {
                    final double chartWidth = max(
                      constraints.maxWidth,
                      widget.chartData.labels.length * _minBarGroupWidth,
                    );
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      child: SizedBox(width: chartWidth, child: barChart),
                    );
                  },
                )
              : barChart,
        );
      },
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
          if (index < widget.chartData.labels.length) {
            final String label = isSingleGroup
                ? l10n.totalLabel
                : widget.chartData.labels[index];
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
    final double animationValue,
  ) {
    final double barWidth;
    if (widget.chartData.labels.length == 1) {
      // Annual view
      barWidth = 24;
    } else if (widget.chartData.labels.length > 1 &&
        widget.chartData.labels.length <= 4) {
      // Seasonal view
      barWidth = 20;
    } else {
      // Monthly view
      barWidth = 16;
    }
    const double spaceBetweenRods = 4;

    return List.generate(
      widget.chartData.labels.length,
      (final i) => BarChartGroupData(
        x: i,
        barRods: widget.chartData.series
            .mapIndexed(
              (final index, final series) => BarChartRodData(
                toY:
                    (isInch ? series.data[i].toInches() : series.data[i]) *
                    animationValue,
                color: colors[index % colors.length],
                width: barWidth,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(2),
                  topRight: Radius.circular(2),
                ),
              ),
            )
            .toList(),
        barsSpace: spaceBetweenRods,
      ),
    );
  }
}
