import "package:flutter/material.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:rainvu/l10n/app_localizations.dart";

part "unusual_patterns_data.freezed.dart";

/// A wrapper class for all data needed on the Unusual Patterns screen.
@freezed
abstract class UnusualPatternsData with _$UnusualPatternsData {
  const factory UnusualPatternsData({
    required final List<RainfallAnomaly> anomalies,
    required final List<AnomalyChartPoint> chartPoints,
  }) = _UnusualPatternsData;
}

/// Represents a single data point for the anomaly timeline chart.
@freezed
abstract class AnomalyChartPoint with _$AnomalyChartPoint {
  const factory AnomalyChartPoint({
    required final DateTime date,
    required final double actualRainfall,
    required final double averageRainfall,
  }) = _AnomalyChartPoint;
}

/// Enum representing the severity of a rainfall anomaly.
enum AnomalySeverity { low, medium, high, critical }

extension AnomalySeverityExtension on AnomalySeverity {
  String getLabel(final AppLocalizations l10n) {
    switch (this) {
      case AnomalySeverity.low:
        return l10n.anomalySeverityLow;
      case AnomalySeverity.medium:
        return l10n.anomalySeverityMedium;
      case AnomalySeverity.high:
        return l10n.anomalySeverityHigh;
      case AnomalySeverity.critical:
        return l10n.anomalySeverityCritical;
    }
  }

  Color get color {
    switch (this) {
      case AnomalySeverity.low:
        return const Color(0xFF946A00); // Dark Yellow for better contrast
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
    required final AnomalySeverity severity,
    required final double deviationPercentage,
    required final double actualRainfall,
    required final double averageRainfall,
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
