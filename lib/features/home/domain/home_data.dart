import "package:freezed_annotation/freezed_annotation.dart";
import "package:rainly/shared/domain/rainfall_entry.dart";

part "home_data.freezed.dart";

@freezed
abstract class HomeData with _$HomeData {
  const factory HomeData({
    required final DateTime currentMonthDate,
    required final double monthlyTotal,
    required final List<RainfallEntry> recentEntries,
    required final List<MonthlyTrendPoint> monthlyTrends,
    required final double ytdTotal,
    required final double annualAverage,
  }) = _HomeData;
}

/// Represents a single data point for the monthly trend chart.
@freezed
abstract class MonthlyTrendPoint with _$MonthlyTrendPoint {
  const factory MonthlyTrendPoint({
    required final String month, // e.g., "Jan"
    required final double rainfall,
  }) = _MonthlyTrendPoint;
}
