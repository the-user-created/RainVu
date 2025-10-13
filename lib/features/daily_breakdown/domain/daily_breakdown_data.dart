import "package:freezed_annotation/freezed_annotation.dart";

part "daily_breakdown_data.freezed.dart";

@freezed
abstract class DailyBreakdownData with _$DailyBreakdownData {
  const factory DailyBreakdownData({
    required final MonthlySummaryStats summaryStats,
    required final PastAveragesStats historicalStats,
    required final List<DailyRainfallPoint> dailyChartData,
  }) = _DailyBreakdownData;
}

@freezed
abstract class MonthlySummaryStats with _$MonthlySummaryStats {
  const factory MonthlySummaryStats({
    required final double totalRainfall,
    required final double dailyAverage,
    required final double highestDay,
    required final double lowestDay,
  }) = _MonthlySummaryStats;
}

@freezed
abstract class PastAveragesStats with _$PastAveragesStats {
  const factory PastAveragesStats({
    required final double twoYearAvg,
    required final double fiveYearAvg,
    required final double tenYearAvg,
  }) = _PastAveragesStats;
}

@freezed
abstract class DailyRainfallPoint with _$DailyRainfallPoint {
  const factory DailyRainfallPoint({
    required final int day,
    required final double rainfall,
  }) = _DailyRainfallPoint;
}
