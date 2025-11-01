import "dart:math";

import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rainvu/core/application/preferences_provider.dart";
import "package:rainvu/core/utils/extensions.dart";
import "package:rainvu/features/home/domain/home_data.dart";
import "package:rainvu/l10n/app_localizations.dart";
import "package:rainvu/shared/domain/user_preferences.dart";
import "package:rainvu/shared/utils/chart_semantics_helper.dart";
import "package:rainvu/shared/widgets/charts/chart_card.dart";

class MonthlyTrendChart extends ConsumerStatefulWidget {
  const MonthlyTrendChart({required this.trends, super.key});

  final List<MonthlyTrendPoint> trends;

  @override
  ConsumerState<MonthlyTrendChart> createState() => _MonthlyTrendChartState();
}

class _MonthlyTrendChartState extends ConsumerState<MonthlyTrendChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  /// Base minimum width for each bar group
  static const double _baseMinBarGroupWidth = 60;

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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Calculate the width of the widest label to determine minimum bar group width
  double _calculateMinBarGroupWidth(
    final BuildContext context,
    final TextScaler textScaler,
  ) {
    final TextStyle labelStyle =
        Theme.of(context).textTheme.bodySmall ?? const TextStyle();

    double maxLabelWidth = 0;

    for (final MonthlyTrendPoint trend in widget.trends) {
      final TextPainter textPainter = TextPainter(
        text: TextSpan(text: trend.month, style: labelStyle),
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
    final TextTheme textTheme = theme.textTheme;
    final TextScaler textScaler = MediaQuery.textScalerOf(context);
    final MeasurementUnit unit =
        ref.watch(userPreferencesProvider).value?.measurementUnit ??
        MeasurementUnit.mm;
    final bool isInch = unit == MeasurementUnit.inch;

    final bool hasData = widget.trends.any((final e) => e.rainfall > 0);

    final Widget legendWidget = Text(
      l10n.monthlyTrendChartSubtitle,
      style: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );

    if (!hasData) {
      return Semantics(
        label: l10n.monthlyTrendChartTitle,
        value: l10n.monthlyTrendChartNoData,
        child: ChartCard(
          title: l10n.monthlyTrendChartTitle,
          legend: legendWidget,
          margin: EdgeInsets.zero,
          chart: SizedBox(
            height: 250,
            child: Center(
              child: Text(
                l10n.monthlyTrendChartNoData,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    }

    final String semanticLabel = ChartSemanticsHelper.getBarChartDescription(
      context: context,
      title: l10n.monthlyTrendChartTitle,
      dataPoints: ChartSemanticsHelper.fromMonthlyTrendPoints(widget.trends),
      unit: unit,
    );

    return Semantics(
      label: l10n.monthlyTrendChartTitle,
      value: semanticLabel,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (final context, final _) {
          final double maxRainfall = widget.trends
              .map((final e) => e.rainfall)
              .reduce(max);
          final double displayMaxRainfall = isInch
              ? maxRainfall.toInches()
              : maxRainfall;

          final BarChart barChart = BarChart(
            BarChartData(
              maxY: (displayMaxRainfall * 1.2).clamp(
                isInch ? 0.5 : 10.0,
                double.infinity,
              ),
              barTouchData: _buildBarTouchData(context, unit),
              titlesData: _buildTitlesData(textTheme),
              gridData: _buildGridData(colorScheme),
              borderData: FlBorderData(show: false),
              barGroups: _buildBarGroups(colorScheme, isInch, _animation.value),
              alignment: BarChartAlignment.spaceAround,
            ),
          );

          // Calculate dynamic minimum bar group width based on label sizes
          final double minBarGroupWidth = _calculateMinBarGroupWidth(
            context,
            textScaler,
          );

          return ChartCard(
            title: l10n.monthlyTrendChartTitle,
            legend: legendWidget,
            margin: EdgeInsets.zero,
            chart: LayoutBuilder(
              builder: (final context, final constraints) {
                final double calculatedWidth =
                    widget.trends.length * minBarGroupWidth;
                final double chartWidth = max(
                  constraints.maxWidth,
                  calculatedWidth,
                );

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: SizedBox(
                    width: chartWidth,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 16,
                        top: 8,
                        bottom: 8,
                      ),
                      child: SizedBox(height: 250, child: barChart),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

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
              final String month = widget.trends[groupIndex].month;

              return BarTooltipItem(
                "$month\n",
                theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onPrimary,
                ),
                children: [
                  TextSpan(
                    text: l10n.rainfallAmountTooltip(formattedValue),
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              );
            },
      ),
    );
  }

  FlTitlesData _buildTitlesData(final TextTheme textTheme) => FlTitlesData(
    topTitles: const AxisTitles(),
    rightTitles: const AxisTitles(),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 40,
        getTitlesWidget: (final value, final meta) {
          final int index = value.toInt();
          if (index >= widget.trends.length) {
            return const Text("");
          }
          return Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(widget.trends[index].month, style: textTheme.bodySmall),
          );
        },
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 50,
        getTitlesWidget: (final value, final meta) {
          if (value == meta.max || value == 0) {
            return const Text("");
          }
          return Text(
            value.round().toString(),
            style: textTheme.bodySmall,
            textAlign: TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.visible,
          );
        },
      ),
    ),
  );

  FlGridData _buildGridData(final ColorScheme colorScheme) => FlGridData(
    drawVerticalLine: false,
    getDrawingHorizontalLine: (final value) => FlLine(
      color: colorScheme.outline.withValues(alpha: 0.5),
      strokeWidth: 1,
    ),
  );

  List<BarChartGroupData> _buildBarGroups(
    final ColorScheme colorScheme,
    final bool isInch,
    final double animationValue,
  ) => widget.trends
      .asMap()
      .entries
      .map(
        (final entry) => BarChartGroupData(
          x: entry.key,
          barRods: [
            BarChartRodData(
              toY:
                  (isInch
                      ? entry.value.rainfall.toInches()
                      : entry.value.rainfall) *
                  animationValue,
              color: colorScheme.tertiary,
              width: 12,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(2),
                topRight: Radius.circular(2),
              ),
            ),
          ],
        ),
      )
      .toList();
}
