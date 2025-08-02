import "package:freezed_annotation/freezed_annotation.dart";

part "seasonal_patterns_data.freezed.dart";

/// An enumeration for the four seasons.
enum Season { spring, summer, autumn, winter }

extension SeasonExtension on Season {
  String get name {
    switch (this) {
      case Season.spring:
        return "Spring";
      case Season.summer:
        return "Summer";
      case Season.autumn:
        return "Autumn";
      case Season.winter:
        return "Winter";
    }
  }
}

/// A wrapper class for all data needed on the Seasonal Patterns screen.
@freezed
abstract class SeasonalPatternsData with _$SeasonalPatternsData {
  const factory SeasonalPatternsData({
    required final SeasonalSummary summary,
    required final List<SeasonalTrendPoint> trendData,
  }) = _SeasonalPatternsData;
}

/// Represents the data for the seasonal summary card.
@freezed
abstract class SeasonalSummary with _$SeasonalSummary {
  const factory SeasonalSummary({
    required final double averageRainfall,
    required final double trendVsHistory, // As a percentage change
    required final double highestRecorded,
    required final double lowestRecorded,
  }) = _SeasonalSummary;
}

/// Represents a single data point for the seasonal trend chart.
@freezed
abstract class SeasonalTrendPoint with _$SeasonalTrendPoint {
  const factory SeasonalTrendPoint({
    required final DateTime date,
    required final double rainfall,
  }) = _SeasonalTrendPoint;
}
