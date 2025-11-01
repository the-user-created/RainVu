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

  /// Appends semantic descriptions for a list of data points to a buffer,
  /// grouping consecutive zero-value points for brevity.
  static void _appendGroupedDataPoints({
    required final BuildContext context,
    required final StringBuffer buffer,
    required final List<({String label, double value})> dataPoints,
    required final MeasurementUnit unit,
  }) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    int i = 0;
    while (i < dataPoints.length) {
      final ({String label, double value}) currentPoint = dataPoints[i];

      if (currentPoint.value == 0) {
        // Find the end of the zero-value sequence
        int j = i;
        while (j + 1 < dataPoints.length && dataPoints[j + 1].value == 0) {
          j++;
        }

        final String startLabel = dataPoints[i].label;
        if (i == j) {
          // Single zero point
          buffer.writeln(l10n.chartSemanticsZeroDataPoint(startLabel));
        } else {
          // Range of zero points
          final String endLabel = dataPoints[j].label;
          buffer.writeln(
            l10n.chartSemanticsZeroDataRange(startLabel, endLabel),
          );
        }
        i = j + 1; // Move index past the processed zero sequence
      } else {
        // Non-zero point
        final String formattedValue = currentPoint.value.formatRainfall(
          context,
          unit,
        );
        buffer.writeln(
          l10n.chartSemanticsDataPoint(currentPoint.label, formattedValue),
        );
        i++;
      }
    }
  }

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

    _appendGroupedDataPoints(
      context: context,
      buffer: buffer,
      dataPoints: dataPoints,
      unit: unit,
    );
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

    final List<({String label, double value})> genericDataPoints = data.map((
      final point,
    ) {
      final String label = DateFormat.yMMMd().format(point.date);
      return (label: label, value: point.rainfall);
    }).toList();

    _appendGroupedDataPoints(
      context: context,
      buffer: buffer,
      dataPoints: genericDataPoints,
      unit: unit,
    );
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

    int i = 0;
    while (i < data.length) {
      final AnomalyChartPoint currentPoint = data[i];

      if (currentPoint.actualRainfall == 0 &&
          currentPoint.averageRainfall == 0) {
        int j = i;
        while (j + 1 < data.length &&
            data[j + 1].actualRainfall == 0 &&
            data[j + 1].averageRainfall == 0) {
          j++;
        }

        final String startLabel = DateFormat.yMMMd().format(data[i].date);
        if (i == j) {
          buffer.writeln(l10n.chartSemanticsZeroDataPoint(startLabel));
        } else {
          final String endLabel = DateFormat.yMMMd().format(data[j].date);
          buffer.writeln(
            l10n.chartSemanticsZeroDataRange(startLabel, endLabel),
          );
        }
        i = j + 1;
      } else {
        final String label = DateFormat.yMMMd().format(currentPoint.date);
        final String actualValue = currentPoint.actualRainfall.formatRainfall(
          context,
          unit,
        );
        final String averageValue = currentPoint.averageRainfall.formatRainfall(
          context,
          unit,
        );
        buffer.writeln(
          l10n.chartSemanticsDualDataPoint(label, actualValue, averageValue),
        );
        i++;
      }
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
      int i = 0;
      while (i < series.data.length) {
        final double value = series.data[i];

        if (value == 0) {
          int j = i;
          while (j + 1 < series.data.length && series.data[j + 1] == 0) {
            j++;
          }

          final String startLabel = isSingleGroup
              ? l10n.totalLabel
              : semanticLabels[i];
          if (i == j) {
            buffer.writeln(
              l10n.chartSemanticsComparativeZeroDataPoint(
                series.year.toString(),
                startLabel,
              ),
            );
          } else {
            final String endLabel = isSingleGroup
                ? l10n.totalLabel
                : semanticLabels[j];
            buffer.writeln(
              l10n.chartSemanticsComparativeZeroDataRange(
                series.year.toString(),
                startLabel,
                endLabel,
              ),
            );
          }
          i = j + 1;
        } else {
          final String label = isSingleGroup
              ? l10n.totalLabel
              : semanticLabels[i];
          final String formattedValue = value.formatRainfall(context, unit);
          buffer.writeln(
            l10n.chartSemanticsComparativeDataPoint(
              series.year.toString(),
              label,
              formattedValue,
            ),
          );
          i++;
        }
      }
    }
    return buffer.toString();
  }

  // --- Mappers to convert feature-specific data models to a generic format ---

  static List<({String label, double value})> fromDailyRainfallPoints(
    final List<DailyRainfallPoint> points,
    final DateTime selectedMonth,
  ) => points.map((final p) {
    final DateTime date = DateTime(
      selectedMonth.year,
      selectedMonth.month,
      p.day,
    );
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
