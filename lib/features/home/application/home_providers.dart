import "dart:async";

import "package:flutter/foundation.dart";
import "package:rain_wise/features/home/domain/home_data.dart";
import "package:rain_wise/features/home/domain/rain_gauge.dart";
import "package:rain_wise/features/home/presentation/widgets/monthly_summary_card.dart";
import "package:rain_wise/features/home/presentation/widgets/quick_stats_card.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "home_providers.g.dart";

/// Provider to fetch all data needed for the home screen in one go.
@riverpod
Future<HomeData> homeScreenData(final HomeScreenDataRef ref) async {
  // In a real app, this would call a repository which fetches data
  // from Firebase or a local DB.
  // For now, we simulate a network delay.
  await Future<void>.delayed(const Duration(seconds: 1));

  // Return mock data
  return const HomeData(
    currentMonth: "July 2024",
    monthlyTotal: "78.5 mm",
    recentEntries: [
      RecentEntry(dateLabel: "Today, 9:15 AM", amount: "12.5 mm"),
      RecentEntry(dateLabel: "Yesterday, 8:30 AM", amount: "8.2 mm"),
      RecentEntry(dateLabel: "July 12, 7:45 AM", amount: "15.3 mm"),
    ],
    quickStats: [
      QuickStat(value: "36.2", label: "mm this week"),
      QuickStat(value: "78.5", label: "mm this month"),
      QuickStat(value: "5.6", label: "mm daily avg"),
    ],
  );
}

/// Provider to fetch the list of user's rain gauges.
@riverpod
Future<List<RainGauge>> userGauges(final UserGaugesRef ref) async {
  // Simulate fetching from a repository
  await Future<void>.delayed(const Duration(milliseconds: 500));
  return const [
    RainGauge(id: "gauge_1", name: "Backyard Gauge"),
    RainGauge(id: "gauge_2", name: "Farm - Field A"),
    RainGauge(id: "gauge_3", name: "Rooftop Collector"),
  ];
}

/// Controller for handling the logic of logging a new rainfall entry.
@riverpod
class LogRainController extends _$LogRainController {
  @override
  FutureOr<void> build() {
    // No-op. This notifier is used for its methods, not its state.
  }

  /// Saves a new rainfall entry.
  Future<bool> saveEntry({
    required final String gaugeId,
    required final double amount,
    required final String unit,
    required final DateTime date,
  }) async {
    // Set state to loading to show a spinner on the button, for example
    state = const AsyncValue.loading();
    try {
      // In a real app, you would call your repository here:
      // await ref.read(rainfallRepositoryProvider).addEntry(...);

      if (kDebugMode) {
        debugPrint(
          "Saving entry: Gauge $gaugeId, $amount $unit on ${date.toIso8601String()}",
        );
      }
      await Future<void>.delayed(const Duration(seconds: 1)); // Simulate save

      // Invalidate the home screen data to force a refetch with the new entry
      ref.invalidate(homeScreenDataProvider);

      state = const AsyncValue.data(null);
      return true; // Success
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false; // Failure
    }
  }
}
