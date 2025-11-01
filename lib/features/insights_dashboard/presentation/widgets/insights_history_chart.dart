import "dart:math";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rainvu/core/application/preferences_provider.dart";
import "package:rainvu/core/utils/extensions.dart";
import "package:rainvu/features/insights_dashboard/domain/insights_data.dart";
import "package:rainvu/l10n/app_localizations.dart";
import "package:rainvu/shared/domain/user_preferences.dart";
import "package:rainvu/shared/utils/chart_semantics_helper.dart";
import "package:rainvu/shared/widgets/charts/chart_card.dart";

class HistoricalChart extends ConsumerWidget {
  const HistoricalChart({required this.points, super.key});

  final List<ChartPoint> points;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool hasData =
        points.isNotEmpty && points.any((final p) => p.value > 0);

    if (!hasData) {
      return Semantics(
        container: true,
        label: l10n.dashboardChartTitle,
        value: l10n.dashboardChartEmptyMessage,
        child: ExcludeSemantics(
          child: ChartCard(
            title: l10n.dashboardChartTitle,
            chart: const _EmptyChartState(),
          ),
        ),
      );
    }

    final ThemeData theme = Theme.of(context);
    final MeasurementUnit unit =
        ref.watch(userPreferencesProvider).value?.measurementUnit ??
        MeasurementUnit.mm;
    final isInch = unit == MeasurementUnit.inch;
    final TextScaler textScaler = MediaQuery.textScalerOf(context);

    // Calculate dynamic minimum bar group width based on label sizes
    final double minBarWidth = _calculateMinBarWidth(context, textScaler);

    final barChart = BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        borderData: FlBorderData(show: false),
        gridData: _buildGridData(theme.colorScheme),
        titlesData: _buildTitlesData(theme, textScaler),
        barGroups: _buildBarGroups(theme.colorScheme, isInch),
        barTouchData: _buildBarTouchData(context, unit),
        maxY: _calculateMaxY(isInch),
      ),
    );

    final String semanticLabel = ChartSemanticsHelper.getBarChartDescription(
      context: context,
      title: l10n.dashboardChartTitle,
      dataPoints: ChartSemanticsHelper.fromChartPoints(points),
      unit: unit,
    );

    return Semantics(
      container: true,
      label: l10n.dashboardChartTitle,
      value: semanticLabel,
      child: ExcludeSemantics(
        child: ChartCard(
          title: l10n.dashboardChartTitle,
          chart: LayoutBuilder(
            builder: (final context, final constraints) {
              final double calculatedWidth = points.length * minBarWidth;
              final double chartWidth = max(
                constraints.maxWidth,
                calculatedWidth,
              );

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                child: SizedBox(
                  width: chartWidth,
                  height: 250,
                  child: barChart,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  double _calculateMaxY(final bool isInch) {
    if (points.isEmpty) {
      return isInch ? 0.5 : 10.0;
    }
    final double maxValue = points.map((final p) => p.value).reduce(max);
    final double displayMax = isInch ? maxValue.toInches() : maxValue;
    return (displayMax * 1.2).clamp(isInch ? 0.5 : 10.0, double.infinity);
  }

  double _calculateMinBarWidth(
    final BuildContext context,
    final TextScaler textScaler,
  ) {
    const double baseMinBarWidth = 48;
    if (points.isEmpty) {
      return baseMinBarWidth;
    }

    final TextStyle labelStyle =
        Theme.of(context).textTheme.bodySmall ?? const TextStyle();
    double maxLabelWidth = 0;

    for (final ChartPoint point in points) {
      final textPainter = TextPainter(
        text: TextSpan(text: point.label, style: labelStyle),
        textDirection: TextDirection.ltr,
        textScaler: textScaler,
      )..layout();
      maxLabelWidth = max(maxLabelWidth, textPainter.width);
    }

    final double padding = max(maxLabelWidth * 0.2, 16);
    return max(baseMinBarWidth, maxLabelWidth + padding);
  }

  FlGridData _buildGridData(final ColorScheme colorScheme) => FlGridData(
    drawVerticalLine: false,
    getDrawingHorizontalLine: (final value) => FlLine(
      color: colorScheme.outline.withValues(alpha: 0.5),
      strokeWidth: 1,
    ),
  );

  FlTitlesData _buildTitlesData(
    final ThemeData theme,
    final TextScaler textScaler,
  ) => FlTitlesData(
    topTitles: const AxisTitles(),
    rightTitles: const AxisTitles(),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30 * textScaler.scale(1),
        getTitlesWidget: (final value, final meta) {
          final int index = value.toInt();
          if (index < 0 || index >= points.length) {
            return const SizedBox();
          }
          return Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(points[index].label, style: theme.textTheme.bodySmall),
          );
        },
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 40 * textScaler.scale(1),
        getTitlesWidget: (final value, final meta) {
          if (value == meta.max || value == 0) {
            return const SizedBox();
          }
          return Text(
            value.toInt().toString(),
            style: theme.textTheme.bodySmall,
          );
        },
      ),
    ),
  );

  BarTouchData _buildBarTouchData(
    final BuildContext context,
    final MeasurementUnit unit,
  ) {
    final ThemeData theme = Theme.of(context);
    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        fitInsideHorizontally: true,
        getTooltipColor: (_) => theme.colorScheme.primary,
        getTooltipItem:
            (final group, final groupIndex, final rod, final rodIndex) {
              final ChartPoint point = points[group.x];
              final String value = point.value.formatRainfall(context, unit);
              return BarTooltipItem(
                "${point.label}\n",
                theme.textTheme.bodyMedium!.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: value,
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

  List<BarChartGroupData> _buildBarGroups(
    final ColorScheme colorScheme,
    final bool isInch,
  ) => points.asMap().entries.map((final entry) {
    final int index = entry.key;
    final ChartPoint point = entry.value;
    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          toY: isInch ? point.value.toInches() : point.value,
          color: colorScheme.secondary,
          width: 16,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }).toList();
}

class _EmptyChartState extends StatelessWidget {
  const _EmptyChartState();

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return SizedBox(
      height: 250,
      child: Center(
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          children: [
            Icon(
              Icons.show_chart_rounded,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.dashboardChartEmptyTitle,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.dashboardChartEmptyMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
