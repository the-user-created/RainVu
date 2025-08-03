import "package:rain_wise/features/insights/domain/anomaly_data.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "anomaly_exploration_repository.g.dart";

abstract class AnomalyExplorationRepository {
  Future<List<RainfallAnomaly>> fetchAnomalies(final AnomalyFilter filter);
}

@riverpod
AnomalyExplorationRepository anomalyExplorationRepository(
  final AnomalyExplorationRepositoryRef ref,
) =>
    MockAnomalyExplorationRepository();

class MockAnomalyExplorationRepository implements AnomalyExplorationRepository {
  final List<RainfallAnomaly> _mockAnomalies = _getMockAnomalies();

  @override
  Future<List<RainfallAnomaly>> fetchAnomalies(
    final AnomalyFilter filter,
  ) async {
    // Simulate network delay for fetching data.
    await Future.delayed(const Duration(milliseconds: 700));

    // In a real app, this filtering would happen on the backend/database.
    return _mockAnomalies.where((final anomaly) {
      final bool isAfterStart = anomaly.date.isAfter(filter.dateRange.start) ||
          anomaly.date.isAtSameMomentAs(filter.dateRange.start);
      final bool isBeforeEnd = anomaly.date.isBefore(filter.dateRange.end) ||
          anomaly.date.isAtSameMomentAs(filter.dateRange.end);
      final bool isInDateRange = isAfterStart && isBeforeEnd;
      final bool hasMatchingSeverity =
          filter.severities.contains(anomaly.severity);

      return isInDateRange && hasMatchingSeverity;
    }).toList();
  }
}

/// Generates a list of mock rainfall anomalies for demonstration.
List<RainfallAnomaly> _getMockAnomalies() {
  final DateTime now = DateTime.now();
  return [
    RainfallAnomaly(
      id: "1",
      date: now.subtract(const Duration(days: 15)),
      description:
          "Significant rainfall spike detected, exceeding historical averages for this period.",
      severity: AnomalySeverity.high,
      deviationPercentage: 245,
    ),
    RainfallAnomaly(
      id: "2",
      date: now.subtract(const Duration(days: 48)),
      description:
          "Extended dry period observed, indicating potential drought conditions.",
      severity: AnomalySeverity.critical,
      deviationPercentage: -75,
    ),
    RainfallAnomaly(
      id: "3",
      date: now.subtract(const Duration(days: 72)),
      description:
          "Unusual precipitation pattern detected during typically dry season.",
      severity: AnomalySeverity.medium,
      deviationPercentage: 180,
    ),
    RainfallAnomaly(
      id: "4",
      date: now.subtract(const Duration(days: 5)),
      description: "Slightly higher than average rainfall for the week.",
      severity: AnomalySeverity.low,
      deviationPercentage: 35,
    ),
    RainfallAnomaly(
      id: "5",
      date: now.subtract(const Duration(days: 110)),
      description:
          "Major storm system passed through, extreme rainfall recorded.",
      severity: AnomalySeverity.critical,
      deviationPercentage: 450,
    ),
  ];
}
