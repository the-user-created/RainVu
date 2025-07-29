import "package:flutter/material.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "anomaly_data.freezed.dart";

/// Enum representing the severity of a rainfall anomaly.
enum AnomalySeverity {
  low,
  medium,
  high,
  critical,
}

extension AnomalySeverityExtension on AnomalySeverity {
  String get label {
    switch (this) {
      case AnomalySeverity.low:
        return "Low";
      case AnomalySeverity.medium:
        return "Medium";
      case AnomalySeverity.high:
        return "High";
      case AnomalySeverity.critical:
        return "Critical";
    }
  }

  Color get color {
    switch (this) {
      case AnomalySeverity.low:
        return const Color(0xFFF9CF58); // Yellow
      case AnomalySeverity.medium:
        return const Color(0xFFEF6C00); // Orange
      case AnomalySeverity.high:
        return const Color(0xFFC62828); // Red
      case AnomalySeverity.critical:
        return const Color(0xFFB71C1C); // Dark Red
    }
  }

  Color get backgroundColor {
    switch (this) {
      case AnomalySeverity.low:
        return const Color(0xFFFFF8E1);
      case AnomalySeverity.medium:
        return const Color(0xFFFFF3E0);
      case AnomalySeverity.high:
        return const Color(0xFFFFEBEE);
      case AnomalySeverity.critical:
        return const Color(0xFFFFEBEE);
    }
  }
}

/// Represents a single detected rainfall anomaly.
@freezed
abstract class RainfallAnomaly with _$RainfallAnomaly {
  const factory RainfallAnomaly({
    required final String id,
    required final DateTime date,
    required final String description,
    required final AnomalySeverity severity,
    required final double deviationPercentage, // e.g., 245.0 for +245%
  }) = _RainfallAnomaly;
}

/// Represents the filter state for the anomaly exploration screen.
@freezed
abstract class AnomalyFilter with _$AnomalyFilter {
  const factory AnomalyFilter({
    required final DateTimeRange dateRange,
    required final Set<AnomalySeverity> severities,
  }) = _AnomalyFilter;
}
