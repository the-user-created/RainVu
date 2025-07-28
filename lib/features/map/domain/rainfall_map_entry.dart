import "package:freezed_annotation/freezed_annotation.dart";

part "rainfall_map_entry.freezed.dart";

@freezed
abstract class RainfallMapEntry with _$RainfallMapEntry {
  const factory RainfallMapEntry({
    required final String id,
    required final DateTime dateTime,
    required final String locationName,
    required final String coordinates,
    required final double amount,
    required final String unit,
  }) = _RainfallMapEntry;
}
