import "package:cloud_firestore/cloud_firestore.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:rain_wise/shared/domain/rain_gauge.dart";

part "rainfall_entry.freezed.dart";

part "rainfall_entry.g.dart";

// Helper for Firestore Timestamps
class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(final Timestamp timestamp) => timestamp.toDate();

  @override
  Timestamp toJson(final DateTime date) => Timestamp.fromDate(date);
}

@freezed
abstract class RainfallEntry with _$RainfallEntry {
  const factory RainfallEntry({
    required final double amount,
    @TimestampConverter() required final DateTime date,
    required final String gaugeId,
    required final String unit,
    @JsonKey(includeIfNull: false) final String? id,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final RainGauge? gauge,
  }) = _RainfallEntry;

  factory RainfallEntry.fromJson(final Map<String, dynamic> json) =>
      _$RainfallEntryFromJson(json);
}
