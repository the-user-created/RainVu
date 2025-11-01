import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:rainvu/core/utils/extensions.dart";
import "package:rainvu/features/daily_breakdown/domain/daily_breakdown_data.dart";
import "package:rainvu/features/home/domain/home_data.dart";
import "package:rainvu/features/insights_dashboard/domain/insights_data.dart";
import "package:rainvu/features/seasonal_trends/domain/seasonal_trends_data.dart";
import "package:rainvu/features/unusual_patterns/domain/unusual_patterns_data.dart";
import "package:rainvu/features/yearly_comparison/domain/yearly_comparison_data.dart";
import "package:rainvu/l10n/app_localizations.dart";
import "package:rainvu/shared/domain/user_preferences.dart";

/// A utility class to generate human-readable descriptions of charts for accessibility.
class ChartSemanticsHelper {
  ChartSemanticsHelper._();

  /// Generates a description for a simple bar chart with one data series.
  static String getBarChartDescription({
    required final BuildContext context,
    required final String title,
    required final List<({String label, double value})> dataPoints,
    required final MeasurementUnit unit,
  }) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    if (dataPoints.isEmpty || dataPoints.every((final p) => p.value == 0)) {
      return l10n.chartSemanticsNoData;
    }

    final StringBuffer buffer = StringBuffer()
      ..writeln(l10n.chartSemanticsLabelBar(title));

    for (final point in dataPoints) {
      final String formattedValue = point.value.formatRainfall(context, unit);
      buffer.writeln(l10n.chartSemanticsDataPoint(point.label, formattedValue));
    }
    return buffer.toString();
  }

  /// Generates a description for a line chart.
  static String getLineChartDescription({
    required final BuildContext context,
    required final String title,
    required final List<SeasonalTrendPoint> data,
    required final MeasurementUnit unit,
  }) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    if (data.isEmpty || data.every((final p) => p.rainfall == 0)) {
      return l10n.chartSemanticsNoData;
    }

    final StringBuffer buffer = StringBuffer()
      ..writeln(l10n.chartSemanticsLabelLine(title));

    for (final point in data) {
      final String label = DateFormat.yMMMd().format(point.date);
      final String formattedValue = point.rainfall.formatRainfall(
        context,
        unit,
      );
      buffer.writeln(l10n.chartSemanticsDataPoint(label, formattedValue));
    }
    return buffer.toString();
  }

  /// Generates a description for a dual-line chart comparing two values.
  static String getDualLineChartDescription({
    required final BuildContext context,
    required final String title,
    required final List<AnomalyChartPoint> data,
    required final MeasurementUnit unit,
  }) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    if (data.isEmpty) {
      return l10n.chartSemanticsNoData;
    }

    final StringBuffer buffer = StringBuffer()
      ..writeln(l10n.chartSemanticsLabelDualLine(title));

    for (final point in data) {
      final String label = DateFormat.yMMMd().format(point.date);
      final String actualValue = point.actualRainfall.formatRainfall(
        context,
        unit,
      );
      final String averageValue = point.averageRainfall.formatRainfall(
        context,
        unit,
      );
      buffer.writeln(
        l10n.chartSemanticsDualDataPoint(label, actualValue, averageValue),
      );
    }
    return buffer.toString();
  }

  /// Generates a description for a comparative bar chart with multiple series.
  static String getComparativeBarChartDescription({
    required final BuildContext context,
    required final String title,
    required final ComparativeChartData data,
    required final MeasurementUnit unit,
  }) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    if (data.series.isEmpty ||
        data.series.every((final s) => s.data.every((final d) => d == 0))) {
      return l10n.chartSemanticsNoData;
    }

    final StringBuffer buffer = StringBuffer()
      ..writeln(l10n.chartSemanticsLabelBar(title));

    final bool isSingleGroup = data.labels.length == 1;
    final List<String> semanticLabels = data.dates != null
        ? data.dates!.map((final d) => DateFormat.MMMM().format(d)).toList()
        : data.labels;

    for (final ComparativeChartSeries series in data.series) {
      for (int i = 0; i < series.data.length; i++) {
        final String label = isSingleGroup
            ? l10n.totalLabel
            : semanticLabels[i];
        final String formattedValue = series.data[i].formatRainfall(
          context,
          unit,
        );
        buffer.writeln(
          l10n.chartSemanticsComparativeDataPoint(
            series.year.toString(),
            label,
            formattedValue,
          ),
        );
      }
    }
    return buffer.toString();
  }

  // --- Mappers to convert feature-specific data models to a generic format ---

  static List<({String label, double value})> fromDailyRainfallPoints(
    final List<DailyRainfallPoint> points,
    final DateTime selectedMonth,
  ) => points.map((final p) {
    final date = DateTime(selectedMonth.year, selectedMonth.month, p.day);
    return (label: DateFormat.yMMMMd().format(date), value: p.rainfall);
  }).toList();

  static List<({String label, double value})> fromMonthlyTrendPoints(
    final List<MonthlyTrendPoint> points,
  ) => points
      .map(
        (final p) =>
            (label: DateFormat.yMMMM().format(p.date), value: p.rainfall),
      )
      .toList();

  static List<({String label, double value})> fromChartPoints(
    final List<ChartPoint> points,
  ) => points.map((final p) {
    String label = p.label;
    if (p.date != null) {
      // MTD data has numeric labels for days
      if (int.tryParse(p.label) != null) {
        label = DateFormat.yMMMMd().format(p.date!);
      }
      // YTD/12-Month data has month abbreviations
      else {
        label = DateFormat.yMMMM().format(p.date!);
      }
    }
    return (label: label, value: p.value);
  }).toList();
}
