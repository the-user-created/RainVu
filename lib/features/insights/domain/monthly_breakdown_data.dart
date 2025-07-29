import "package:freezed_annotation/freezed_annotation.dart";

part "monthly_breakdown_data.freezed.dart";

@freezed
abstract class MonthlyBreakdownData with _$MonthlyBreakdownData {
  const factory MonthlyBreakdownData({
    required final MonthlySummaryStats summaryStats,
    required final HistoricalComparisonStats historicalStats,
    required final List<DailyRainfallPoint> dailyChartData,
    required final List<DailyBreakdownItem> dailyBreakdownList,
  }) = _MonthlyBreakdownData;
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
abstract class HistoricalComparisonStats with _$HistoricalComparisonStats {
  const factory HistoricalComparisonStats({
    required final double twoYearAvg,
    required final double fiveYearAvg,
    required final double tenYearAvg,
  }) = _HistoricalComparisonStats;
}

@freezed
abstract class DailyRainfallPoint with _$DailyRainfallPoint {
  const factory DailyRainfallPoint({
    required final int day,
    required final double rainfall,
  }) = _DailyRainfallPoint;
}

@freezed
abstract class DailyBreakdownItem with _$DailyBreakdownItem {
  const factory DailyBreakdownItem({
    required final DateTime date,
    required final double rainfall,
    required final double variance,
  }) = _DailyBreakdownItem;
}
