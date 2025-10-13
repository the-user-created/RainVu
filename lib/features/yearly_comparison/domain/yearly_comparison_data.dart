import "package:freezed_annotation/freezed_annotation.dart";

part "yearly_comparison_data.freezed.dart";

/// Defines the type of comparison to perform.
enum ComparisonType { annual, monthly, seasonal }

/// Holds the filter state for the yearly comparison screen.
@freezed
abstract class ComparativeFilter with _$ComparativeFilter {
  const factory ComparativeFilter({
    /// The first year to compare.
    required final int year1,

    /// The second year to compare.
    required final int year2,

    /// The type of data comparison.
    @Default(ComparisonType.annual) final ComparisonType type,
  }) = _ComparativeFilter;
}

/// Contains all the data needed to display the yearly comparison screen.
@freezed
abstract class YearlyComparisonData with _$YearlyComparisonData {
  const factory YearlyComparisonData({
    required final List<YearlySummary> summaries,
    required final ComparativeChartData chartData,
  }) = _YearlyComparisonData;
}

/// Represents the summary data for a single year in the comparison.
@freezed
abstract class YearlySummary with _$YearlySummary {
  const factory YearlySummary({
    required final int year,
    required final double totalRainfall,
    required final double percentageChange, // Compared to the other year.
  }) = _YearlySummary;
}

/// Represents the data needed to render the comparison chart.
@freezed
abstract class ComparativeChartData with _$ComparativeChartData {
  const factory ComparativeChartData({
    /// Labels for the X-axis (e.g., 'Jan', 'Feb', ...).
    required final List<String> labels,

    /// The data series, one for each year being compared.
    required final List<ComparativeChartSeries> series,
  }) = _ComparativeChartData;
}

/// Represents a single data series for the chart (e.g., data for '2023').
@freezed
abstract class ComparativeChartSeries with _$ComparativeChartSeries {
  const factory ComparativeChartSeries({
    required final int year,
    required final List<double> data,
  }) = _ComparativeChartSeries;
}
