import "package:freezed_annotation/freezed_annotation.dart";

part "insights_data.freezed.dart";

/// An enum representing the different metrics the user can select on the dashboard.
enum DashboardMetric { mtd, ytd, last12Months, allTime }

/// A wrapper class for all data needed on the redesigned Insights screen.
@freezed
abstract class InsightsData with _$InsightsData {
  const factory InsightsData({
    /// Data for the MTD metric view.
    required final MetricData mtdData,

    /// Data for the YTD metric view.
    required final MetricData ytdData,

    /// Data for the Last 12 Months metric view.
    required final MetricData last12MonthsData,

    /// Data for the All Time metric view.
    required final MetricData allTimeData,

    /// Data for the monthly averages screen.
    required final List<MonthlyAveragesData> monthlyAverages,
  }) = _InsightsData;
}

/// Represents the data for a single selectable metric on the dashboard.
@freezed
abstract class MetricData with _$MetricData {
  const factory MetricData({
    /// The primary value for the metric (e.g., total MTD rainfall).
    required final double primaryValue,

    /// The percentage change compared to a previous period or average.
    required final double changePercentage,

    /// A descriptive label for the comparison (e.g., "vs previous period").
    required final String changeLabel,

    /// A list of data points for rendering the historical chart.
    required final List<ChartPoint> chartPoints,
  }) = _MetricData;
}

/// Represents a single data point for a chart.
@freezed
abstract class ChartPoint with _$ChartPoint {
  const factory ChartPoint({
    /// The label for the x-axis (e.g., "Jan", "2023").
    required final String label,

    /// The value for the y-axis (e.g., total rainfall).
    required final double value,

    /// The full date context for the data point, used for semantics.
    final DateTime? date,
  }) = _ChartPoint;
}

/// Represents the data for a single monthly averages card.
@freezed
abstract class MonthlyAveragesData with _$MonthlyAveragesData {
  const factory MonthlyAveragesData({
    required final String month,
    required final double mtdTotal,
    final double? twoYrAvg,
    final double? fiveYrAvg,
    final double? tenYrAvg,
    final double? fifteenYrAvg,
    final double? twentyYrAvg,
  }) = _MonthlyAveragesData;
}
