import "package:freezed_annotation/freezed_annotation.dart";
import "package:rainly/shared/domain/rain_gauge.dart";

part "rainfall_entry.freezed.dart";

part "rainfall_entry.g.dart";

@freezed
abstract class RainfallEntry with _$RainfallEntry {
  const factory RainfallEntry({
    required final double amount,
    required final DateTime date,
    required final String gaugeId,
    required final String unit,
    final String? id,
    @JsonKey(
      includeFromJson: false,
      includeToJson: false,
    )
    final RainGauge? gauge,
  }) = _RainfallEntry;

  factory RainfallEntry.fromJson(final Map<String, dynamic> json) =>
      _$RainfallEntryFromJson(json);
}
