import "package:freezed_annotation/freezed_annotation.dart";

part "insights_data.freezed.dart";

/// A wrapper class for all data needed on the Insights screen.
@freezed
abstract class InsightsData with _$InsightsData {
  const factory InsightsData({
    required final KeyMetrics keyMetrics,
    required final List<MonthlyTrendPoint> monthlyTrends,
    required final List<MonthlyComparisonData> monthlyComparisons,
  }) = _InsightsData;
}

/// Represents the data for the Key Metrics section.
@freezed
abstract class KeyMetrics with _$KeyMetrics {
  const factory KeyMetrics({
    required final double totalRainfall,
    required final double totalRainfallPrevYearChange,
    required final double mtdTotal,
    required final double mtdTotalPrevMonthChange,
    required final double ytdTotal,
    required final double monthlyAvg,
  }) = _KeyMetrics;
}

/// Represents a single data point for the monthly trend chart.
@freezed
abstract class MonthlyTrendPoint with _$MonthlyTrendPoint {
  const factory MonthlyTrendPoint({
    required final String month, // e.g., "Jan"
    required final double rainfall,
  }) = _MonthlyTrendPoint;
}

/// Represents the data for a single MTD (Month-to-Date) breakdown card.
@freezed
abstract class MonthlyComparisonData with _$MonthlyComparisonData {
  const factory MonthlyComparisonData({
    required final String month, // e.g., "January"
    required final int mtdTotal,
    required final int twoYrAvg,
    required final int fiveYrAvg,
  }) = _MonthlyComparisonData;
}
