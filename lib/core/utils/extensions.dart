import "package:flutter/material.dart";
import "package:rainvu/l10n/app_localizations.dart";
import "package:rainvu/shared/domain/user_preferences.dart";

extension ListDivideExt<T extends Widget> on Iterable<T> {
  Iterable<MapEntry<int, Widget>> get enumerate => toList().asMap().entries;

  List<Widget> divide(final Widget t, {final bool Function(int)? filterFn}) =>
      isEmpty
      ? []
      : (enumerate
            .map(
              (final e) => [
                e.value,
                if (filterFn == null || filterFn(e.key)) t,
              ],
            )
            .expand((final i) => i)
            .toList()
          ..removeLast());

  List<Widget> around(final Widget t) => addToStart(t).addToEnd(t);

  List<Widget> addToStart(final Widget t) =>
      enumerate.map((final e) => e.value).toList()..insert(0, t);

  List<Widget> addToEnd(final Widget t) =>
      enumerate.map((final e) => e.value).toList()..add(t);

  List<Padding> paddingTopEach(final double val) => map(
    (final w) => Padding(
      padding: EdgeInsets.only(top: val),
      child: w,
    ),
  ).toList();
}

extension ListUniqueExt<T> on Iterable<T> {
  List<T> unique(final dynamic Function(T) getKey) {
    final distinctSet = <dynamic>{};
    final distinctList = <T>[];
    for (final item in this) {
      if (distinctSet.add(getKey(item))) {
        distinctList.add(item);
      }
    }
    return distinctList;
  }
}

extension DoubleFormattingExt on double {
  /// Formats a double as a percentage string with configurable precision,
  /// symbol, and sign display.
  String formatPercentage({
    final int precision = 1,
    final bool withSymbol = true,
    final bool showPositiveSign = false,
  }) {
    if (isNaN || isInfinite) {
      return "-";
    }

    String sign = "";
    if (this > 0 && showPositiveSign) {
      sign = "+";
    }

    final String formattedValue = toStringAsFixed(precision);
    final String symbol = withSymbol ? "%" : "";

    return "$sign$formattedValue$symbol";
  }
}

extension DoubleUnitsExt on double {
  /// Converts a value from millimeters to inches.
  double toInches() => this / 25.4;

  /// Converts a value from inches to millimeters.
  double toMillimeters() => this * 25.4;

  /// Formats the rainfall amount (assumed to be in mm) according to the
  /// preferred measurement unit.
  String formatRainfall(
    final BuildContext context,
    final MeasurementUnit unit, {
    final int precision = 1,
    final bool withUnit = true,
  }) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    if (unit == MeasurementUnit.inch) {
      final double amountInInches = toInches();
      if (!withUnit) {
        return amountInInches.toStringAsFixed(precision);
      }
      return l10n.rainfallAmountWithUnitIn(
        amountInInches.toStringAsFixed(precision),
      );
    }
    if (!withUnit) {
      return toStringAsFixed(precision);
    }
    return l10n.rainfallAmountWithUnit(toStringAsFixed(precision));
  }
}

extension DateTimeExtension on DateTime {
  /// Returns a new DateTime object with the time set to the beginning of the day (00:00:00).
  DateTime get startOfDay => DateTime(year, month, day);

  /// Returns a new DateTime object with the time set to the end of the day (23:59:59.999).
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);
}

// ignore: camel_case_extensions
extension iOSKeyboardConfig on BuildContext {
  Color get iOSKeyboardBgColor => Theme.of(this).brightness == Brightness.dark
      ? const Color(0xFF2E3030)
      : const Color(0xFFCAD1D9);
}
