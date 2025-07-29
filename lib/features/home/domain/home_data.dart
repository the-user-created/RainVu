import "package:freezed_annotation/freezed_annotation.dart";
import "package:rain_wise/features/home/presentation/widgets/monthly_summary_card.dart";
import "package:rain_wise/features/home/presentation/widgets/quick_stats_card.dart";

part "home_data.freezed.dart";

// This file would typically also have fromJson if fetching from a single endpoint
@freezed
abstract class HomeData with _$HomeData {
  const factory HomeData({
    required final String currentMonth,
    required final String monthlyTotal,
    required final List<RecentEntry> recentEntries,
    required final List<QuickStat> quickStats,
    // We would add forecast and trends data here too
  }) = _HomeData;
}
