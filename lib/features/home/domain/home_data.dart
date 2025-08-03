import "package:freezed_annotation/freezed_annotation.dart";

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

class RecentEntry {
  const RecentEntry({required this.dateLabel, required this.amount});

  final String dateLabel;
  final String amount;
}

class QuickStat {
  const QuickStat({required this.value, required this.label});

  final String value;
  final String label;
}
