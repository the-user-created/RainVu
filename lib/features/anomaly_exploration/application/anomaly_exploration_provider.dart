import "package:flutter/material.dart";
import "package:rain_wise/features/anomaly_exploration/data/anomaly_exploration_repository.dart";
import "package:rain_wise/features/anomaly_exploration/domain/anomaly_data.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "anomaly_exploration_provider.g.dart";

@riverpod
class AnomalyFilterNotifier extends _$AnomalyFilterNotifier {
  @override
  AnomalyFilter build() {
    final DateTime now = DateTime.now();
    return AnomalyFilter(
      dateRange: DateTimeRange(
        start: now.subtract(const Duration(days: 90)),
        end: now,
      ),
      severities: AnomalySeverity.values.toSet(),
    );
  }

  void setDateRange(final DateTimeRange newRange) {
    state = state.copyWith(dateRange: newRange);
  }

  void toggleSeverity(final AnomalySeverity severity) {
    final Set<AnomalySeverity> newSeverities = Set.from(state.severities);
    if (newSeverities.contains(severity)) {
      newSeverities.remove(severity);
    } else {
      newSeverities.add(severity);
    }
    state = state.copyWith(severities: newSeverities);
  }
}

@riverpod
Future<AnomalyExplorationData> anomalyData(final AnomalyDataRef ref) async {
  final AnomalyFilter filter = ref.watch(anomalyFilterNotifierProvider);
  final AnomalyExplorationRepository repo =
      ref.watch(anomalyExplorationRepositoryProvider);
  return repo.fetchAnomalyData(filter);
}
