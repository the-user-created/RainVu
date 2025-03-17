import "package:collection/collection.dart";

enum WeatherIcon {
  sunny,
  cloudy,
  rainy,
  thunderstorm,
  snowy,
  windy,
  foggy,
}

extension FFEnumExtensions<T extends Enum> on T {
  String serialize() => name;
}

extension FFEnumListExtensions<T extends Enum> on Iterable<T> {
  T? deserialize(final String? value) =>
      firstWhereOrNull((final e) => e.serialize() == value);
}

T? deserializeEnum<T>(final String? value) {
  switch (T) {
    case (WeatherIcon _):
      return WeatherIcon.values.deserialize(value) as T?;
    default:
      return null;
  }
}
