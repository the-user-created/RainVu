import "dart:math";

import "package:collection/collection.dart";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rainly/core/application/preferences_provider.dart";
import "package:rainly/core/utils/extensions.dart";
import "package:rainly/features/yearly_comparison/domain/yearly_comparison_data.dart";
import "package:rainly/l10n/app_localizations.dart";
import "package:rainly/shared/domain/user_preferences.dart";
import "package:rainly/shared/widgets/charts/chart_card.dart";
import "package:rainly/shared/widgets/charts/legend_item.dart";

class YearlyComparisonChart extends ConsumerStatefulWidget {
  const YearlyComparisonChart({required this.chartData, super.key});

  final ComparativeChartData chartData;

  @override
  ConsumerState<YearlyComparisonChart> createState() =>
      _YearlyComparisonChartState();
}

class _YearlyComparisonChartState extends ConsumerState<YearlyComparisonChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  /// Base minimum width for each bar group
  static const double _baseMinBarGroupWidth = 48;

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
  void didUpdateWidget(covariant final YearlyComparisonChart oldWidget) {
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

  /// Calculate the width of the widest label to determine minimum bar group width
  double _calculateMinBarGroupWidth(
    final BuildContext context,
    final AppLocalizations l10n,
    final TextScaler textScaler,
    final bool isSingleGroup,
  ) {
    final TextStyle labelStyle =
        Theme.of(context).textTheme.bodySmall ?? const TextStyle();

    double maxLabelWidth = 0;
    final List<String> labelsToMeasure = isSingleGroup
        ? [l10n.totalLabel]
        : widget.chartData.labels;

    for (final String label in labelsToMeasure) {
      final TextPainter textPainter = TextPainter(
        text: TextSpan(text: label, style: labelStyle),
        textDirection: TextDirection.ltr,
        textScaler: textScaler,
      )..layout();

      maxLabelWidth = max(maxLabelWidth, textPainter.width);
    }

    // Add padding between labels (20% of label width, minimum 16px)
    final double padding = max(maxLabelWidth * 0.2, 16);

    // Ensure minimum width accounts for the label plus padding
    return max(_baseMinBarGroupWidth, maxLabelWidth + padding);
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextScaler textScaler = MediaQuery.textScalerOf(context);
    final List<Color> colors = [colorScheme.secondary, colorScheme.tertiary];
    final MeasurementUnit unit =
        ref.watch(userPreferencesProvider).value?.measurementUnit ??
        MeasurementUnit.mm;
    final bool isInch = unit == MeasurementUnit.inch;
    final bool isSingleGroup = widget.chartData.labels.length == 1;

    if (widget.chartData.series.isEmpty ||
        widget.chartData.series.first.data.isEmpty) {
      return SizedBox(
        height: 300,
        child: Center(child: Text(l10n.yearlyComparisonChartNoData)),
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

    // Calculate dynamic minimum bar group width based on label sizes
    final double minBarGroupWidth = _calculateMinBarGroupWidth(
      context,
      l10n,
      textScaler,
      isSingleGroup,
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
            titlesData: _buildTitles(theme, l10n, isSingleGroup, textScaler),
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
          title: l10n.yearlyComparisonChartTitle,
          margin: const EdgeInsets.all(16),
          legend: Wrap(
            spacing: 12,
            runSpacing: 4,
            children: widget.chartData.series
                .mapIndexed(
                  (final index, final series) => LegendItem(
                    color: colors[index % colors.length],
                    text: series.year.toString(),
                  ),
                )
                .toList(),
          ),
          chart: LayoutBuilder(
            builder: (final context, final constraints) {
              final double chartWidth = max(
                constraints.maxWidth,
                widget.chartData.labels.length * minBarGroupWidth,
              );
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                child: SizedBox(
                  width: chartWidth,
                  height: 260,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, right: 16),
                    child: barChart,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  FlTitlesData _buildTitles(
    final ThemeData theme,
    final AppLocalizations l10n,
    final bool isSingleGroup,
    final TextScaler textScaler,
  ) {
    // Dynamically scale the reserved size for axis titles based on font size.
    final double bottomReservedSize = 40 * textScaler.scale(1);
    final double leftReservedSize = 40 * textScaler.scale(1);

    return FlTitlesData(
      rightTitles: const AxisTitles(),
      topTitles: const AxisTitles(),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: bottomReservedSize,
          getTitlesWidget: (final value, final meta) {
            final int index = value.toInt();
            if (index < widget.chartData.labels.length) {
              final String label = isSingleGroup
                  ? l10n.totalLabel
                  : widget.chartData.labels[index];
              return SideTitleWidget(
                meta: meta,
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
          reservedSize: leftReservedSize,
          getTitlesWidget: (final value, final meta) {
            if (value == 0 || value == meta.max) {
              return const Text("");
            }
            return SideTitleWidget(
              meta: meta,
              child: Text(
                value.toInt().toString(),
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.right,
              ),
            );
          },
        ),
      ),
    );
  }

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
