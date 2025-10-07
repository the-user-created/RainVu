import "package:flutter/material.dart";
import "package:rain_wise/core/data/providers/data_providers.dart";
import "package:rain_wise/core/data/repositories/rainfall_repository.dart";
import "package:rain_wise/features/anomaly_exploration/data/anomaly_exploration_repository.dart";
import "package:rain_wise/features/anomaly_exploration/domain/anomaly_data.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "anomaly_exploration_provider.g.dart";

@riverpod
class AnomalyFilterNotifier extends _$AnomalyFilterNotifier {
  @override
  Future<AnomalyFilter> build() async {
    final dateRangeResult = await ref.watch(rainfallDateRangeProvider.future);
    final DateTime now = DateTime.now();

    final DateTime endDate = dateRangeResult.max ?? now;
    DateTime startDate;

    if (dateRangeResult.min == null) {
      // Case 1: No data exists at all. Default to the last 90 days.
      startDate = now.subtract(const Duration(days: 90));
    } else {
      final DateTime oneYearBeforeEnd = endDate.subtract(
        const Duration(days: 365),
      );
      if (oneYearBeforeEnd.isAfter(dateRangeResult.min!)) {
        // Case 2: At least one year of data exists. Default to the last year.
        startDate = oneYearBeforeEnd;
      } else {
        // Case 3: Less than one year of data. Use the maximum available range.
        startDate = dateRangeResult.min!;
      }
    }

    return AnomalyFilter(
      dateRange: DateTimeRange(start: startDate, end: endDate),
      severities: AnomalySeverity.values.toSet(),
    );
  }

  Future<void> setDateRange(final DateTimeRange newRange) async {
    final AnomalyFilter currentState = await future;
    state = AsyncData(currentState.copyWith(dateRange: newRange));
  }

  Future<void> toggleSeverity(final AnomalySeverity severity) async {
    final AnomalyFilter currentState = await future;
    final Set<AnomalySeverity> newSeverities = Set.from(
      currentState.severities,
    );
    if (newSeverities.contains(severity)) {
      newSeverities.remove(severity);
    } else {
      newSeverities.add(severity);
    }
    state = AsyncData(currentState.copyWith(severities: newSeverities));
  }
}

@riverpod
Future<AnomalyExplorationData> anomalyData(final Ref ref) async {
  ref.watch(rainfallRepositoryProvider).watchTableUpdates();

  // Await the filter provider, which is now async. This will propagate loading
  // and error states automatically.
  final AnomalyFilter filter = await ref.watch(anomalyFilterProvider.future);
  final AnomalyExplorationRepository repo = ref.watch(
    anomalyExplorationRepositoryProvider,
  );
  return repo.fetchAnomalyData(filter);
}
