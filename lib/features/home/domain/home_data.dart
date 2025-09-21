import "package:freezed_annotation/freezed_annotation.dart";
import "package:rain_wise/shared/domain/rainfall_entry.dart";

part "home_data.freezed.dart";

enum QuickStatType { thisWeek, thisMonth, dailyAvg }

@freezed
abstract class HomeData with _$HomeData {
  const factory HomeData({
    required final DateTime currentMonthDate,
    required final double monthlyTotal,
    required final List<RainfallEntry> recentEntries,
    required final List<QuickStat> quickStats,
    required final List<MonthlyTrendPoint> monthlyTrends,
  }) = _HomeData;
}

@freezed
abstract class QuickStat with _$QuickStat {
  const factory QuickStat({
    required final double value,
    required final QuickStatType type,
  }) = _QuickStat;
}

/// Represents a single data point for the monthly trend chart.
@freezed
abstract class MonthlyTrendPoint with _$MonthlyTrendPoint {
  const factory MonthlyTrendPoint({
    required final String month, // e.g., "Jan"
    required final double rainfall,
  }) = _MonthlyTrendPoint;
}
