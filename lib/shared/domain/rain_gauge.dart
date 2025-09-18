import "package:freezed_annotation/freezed_annotation.dart";

part "rain_gauge.freezed.dart";

part "rain_gauge.g.dart";

@freezed
abstract class RainGauge with _$RainGauge {
  const factory RainGauge({
    required final String id,
    required final String name,
  }) = _RainGauge;

  factory RainGauge.fromJson(final Map<String, dynamic> json) =>
      _$RainGaugeFromJson(json);
}
