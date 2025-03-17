import "dart:io";
import "dart:math" show pi, pow, sin;

import "package:cloud_firestore/cloud_firestore.dart";
import "package:collection/collection.dart";
import "package:flutter/foundation.dart" show kIsWeb;
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:from_css_color/from_css_color.dart";
import "package:intl/intl.dart";
import "package:json_path/json_path.dart";
import "package:timeago/timeago.dart" as timeago;
import "package:url_launcher/url_launcher.dart";

export "dart:convert" show jsonDecode, jsonEncode;
export "dart:math" show max, min;
export "dart:typed_data" show Uint8List;

export "package:cloud_firestore/cloud_firestore.dart"
    show DocumentReference, FirebaseFirestore;
export "package:intl/intl.dart";
export "package:page_transition/page_transition.dart";

export "/backend/firebase_analytics/analytics.dart";
export "../app_constants.dart";
export "../app_state.dart";
export "flutter_flow_model.dart";
export "internationalization.dart" show FFLocalizations;
export "keep_alive_wrapper.dart";
export "lat_lng.dart";
export "nav/nav.dart";
export "place.dart";
export "uploaded_file.dart";

T valueOrDefault<T>(final T? value, final T defaultValue) =>
    (value is String && value.isEmpty) || value == null ? defaultValue : value;

void _setTimeagoLocales() {
  timeago.setLocaleMessages("en", timeago.EnMessages());
  timeago.setLocaleMessages("en_short", timeago.EnShortMessages());
}

String dateTimeFormat(final String format, final DateTime? dateTime,
    {final String? locale}) {
  if (dateTime == null) {
    return "";
  }
  if (format == "relative") {
    _setTimeagoLocales();
    return timeago.format(dateTime, locale: locale, allowFromNow: true);
  }
  return DateFormat(format, locale).format(dateTime);
}

Theme wrapInMaterialDatePickerTheme(
  final BuildContext context,
  final Widget child, {
  required final Color headerBackgroundColor,
  required final Color headerForegroundColor,
  required final TextStyle headerTextStyle,
  required final Color pickerBackgroundColor,
  required final Color pickerForegroundColor,
  required final Color selectedDateTimeBackgroundColor,
  required final Color selectedDateTimeForegroundColor,
  required final Color actionButtonForegroundColor,
  required final double iconSize,
}) {
  final ThemeData baseTheme = Theme.of(context);
  final WidgetStateProperty<Color?> dateTimeMaterialStateForegroundColor =
      WidgetStateProperty.resolveWith((final states) {
    if (states.contains(WidgetState.disabled)) {
      return pickerForegroundColor.applyAlpha(0.60);
    }
    if (states.contains(WidgetState.selected)) {
      return selectedDateTimeForegroundColor;
    }
    if (states.isEmpty) {
      return pickerForegroundColor;
    }
    return null;
  });

  final WidgetStateProperty<Color?> dateTimeMaterialStateBackgroundColor =
      WidgetStateProperty.resolveWith((final states) {
    if (states.contains(WidgetState.selected)) {
      return selectedDateTimeBackgroundColor;
    }
    return null;
  });

  return Theme(
    data: baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        onSurface: pickerForegroundColor,
      ),
      disabledColor: pickerForegroundColor.applyAlpha(0.3),
      textTheme: baseTheme.textTheme.copyWith(
        headlineSmall: headerTextStyle,
        headlineMedium: headerTextStyle,
      ),
      iconTheme: baseTheme.iconTheme.copyWith(
        size: iconSize,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(
              actionButtonForegroundColor,
            ),
            overlayColor: WidgetStateProperty.resolveWith((final states) {
              if (states.contains(WidgetState.hovered)) {
                return actionButtonForegroundColor.applyAlpha(0.04);
              }
              if (states.contains(WidgetState.focused) ||
                  states.contains(WidgetState.pressed)) {
                return actionButtonForegroundColor.applyAlpha(0.12);
              }
              return null;
            })),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: pickerBackgroundColor,
        headerBackgroundColor: headerBackgroundColor,
        headerForegroundColor: headerForegroundColor,
        weekdayStyle: baseTheme.textTheme.labelMedium!.copyWith(
          color: pickerForegroundColor,
        ),
        dayBackgroundColor: dateTimeMaterialStateBackgroundColor,
        todayBackgroundColor: dateTimeMaterialStateBackgroundColor,
        yearBackgroundColor: dateTimeMaterialStateBackgroundColor,
        dayForegroundColor: dateTimeMaterialStateForegroundColor,
        todayForegroundColor: dateTimeMaterialStateForegroundColor,
        yearForegroundColor: dateTimeMaterialStateForegroundColor,
      ),
    ),
    child: child,
  );
}

Theme wrapInMaterialTimePickerTheme(
  final BuildContext context,
  final Widget child, {
  required final Color headerBackgroundColor,
  required final Color headerForegroundColor,
  required final TextStyle headerTextStyle,
  required final Color pickerBackgroundColor,
  required final Color pickerForegroundColor,
  required final Color selectedDateTimeBackgroundColor,
  required final Color selectedDateTimeForegroundColor,
  required final Color actionButtonForegroundColor,
  required final double iconSize,
}) {
  final ThemeData baseTheme = Theme.of(context);
  return Theme(
    data: baseTheme.copyWith(
      iconTheme: baseTheme.iconTheme.copyWith(
        size: iconSize,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(
              actionButtonForegroundColor,
            ),
            overlayColor: WidgetStateProperty.resolveWith((final states) {
              if (states.contains(WidgetState.hovered)) {
                return actionButtonForegroundColor.applyAlpha(0.04);
              }
              if (states.contains(WidgetState.focused) ||
                  states.contains(WidgetState.pressed)) {
                return actionButtonForegroundColor.applyAlpha(0.12);
              }
              return null;
            })),
      ),
      timePickerTheme: baseTheme.timePickerTheme.copyWith(
        backgroundColor: pickerBackgroundColor,
        hourMinuteTextColor: pickerForegroundColor,
        dialHandColor: selectedDateTimeBackgroundColor,
        dialTextColor: WidgetStateColor.resolveWith((final states) =>
            states.contains(WidgetState.selected)
                ? selectedDateTimeForegroundColor
                : pickerForegroundColor),
        dayPeriodBorderSide: BorderSide(
          color: pickerForegroundColor,
        ),
        dayPeriodTextColor: WidgetStateColor.resolveWith((final states) =>
            states.contains(WidgetState.selected)
                ? selectedDateTimeForegroundColor
                : pickerForegroundColor),
        dayPeriodColor: WidgetStateColor.resolveWith((final states) =>
            states.contains(WidgetState.selected)
                ? selectedDateTimeBackgroundColor
                : Colors.transparent),
        entryModeIconColor: pickerForegroundColor,
      ),
    ),
    child: child,
  );
}

class LaunchUrlException implements Exception {
  LaunchUrlException(this.message);

  final String message;

  @override
  String toString() => "LaunchUrlException: $message";
}

Future launchURL(final String url) async {
  Uri uri = Uri.parse(url);
  try {
    await launchUrl(uri);
  } catch (e) {
    throw LaunchUrlException("Could not launch $uri: $e");
  }
}

Color colorFromCssString(final String color, {final Color? defaultColor}) {
  try {
    return fromCssColor(color);
  } on Exception catch (_) {}
  return defaultColor ?? Colors.black;
}

enum FormatType {
  decimal,
  percent,
  scientific,
  compact,
  compactLong,
  custom,
}

enum DecimalType {
  automatic,
  periodDecimal,
  commaDecimal,
}

String formatNumber(
  final num? value, {
  required final FormatType formatType,
  final DecimalType? decimalType,
  final String? currency,
  final bool toLowerCase = false,
  final String? format,
  final String? locale,
}) {
  if (value == null) {
    return "";
  }
  var formattedValue = "";
  switch (formatType) {
    case FormatType.decimal:
      switch (decimalType!) {
        case DecimalType.automatic:
          formattedValue = NumberFormat.decimalPattern().format(value);
        case DecimalType.periodDecimal:
          if (currency != null) {
            formattedValue = NumberFormat("#,##0.00", "en_US").format(value);
          } else {
            formattedValue = NumberFormat.decimalPattern("en_US").format(value);
          }
        case DecimalType.commaDecimal:
          if (currency != null) {
            formattedValue = NumberFormat("#,##0.00", "es_PA").format(value);
          } else {
            formattedValue = NumberFormat.decimalPattern("es_PA").format(value);
          }
      }
    case FormatType.percent:
      formattedValue = NumberFormat.percentPattern().format(value);
    case FormatType.scientific:
      formattedValue = NumberFormat.scientificPattern().format(value);
      if (toLowerCase) {
        formattedValue = formattedValue.toLowerCase();
      }
    case FormatType.compact:
      formattedValue = NumberFormat.compact().format(value);
    case FormatType.compactLong:
      formattedValue = NumberFormat.compactLong().format(value);
    case FormatType.custom:
      final bool hasLocale = locale != null && locale.isNotEmpty;
      formattedValue =
          NumberFormat(format, hasLocale ? locale : null).format(value);
  }

  if (formattedValue.isEmpty) {
    return value.toString();
  }

  if (currency != null) {
    final String currencySymbol = currency.isNotEmpty
        ? currency
        : NumberFormat.simpleCurrency().format(0.0).substring(0, 1);
    formattedValue = "$currencySymbol$formattedValue";
  }

  return formattedValue;
}

DateTime get getCurrentTimestamp => DateTime.now();

DateTime dateTimeFromSecondsSinceEpoch(final int seconds) =>
    DateTime.fromMillisecondsSinceEpoch(seconds * 1000);

extension DateTimeConversionExtension on DateTime {
  int get secondsSinceEpoch => (millisecondsSinceEpoch / 1000).round();
}

extension DateTimeComparisonOperators on DateTime {
  bool operator <(final DateTime other) => isBefore(other);

  bool operator >(final DateTime other) => isAfter(other);

  bool operator <=(final DateTime other) =>
      this < other || isAtSameMomentAs(other);

  bool operator >=(final DateTime other) =>
      this > other || isAtSameMomentAs(other);
}

T? castToType<T>(final dynamic value) {
  if (value == null) {
    return null;
  }
  if (T == double) {
    // Doubles may be stored as ints in some cases.
    // Ensure value is a num before calling toDouble.
    return (value as num).toDouble() as T;
  }
  if (T == int) {
    // Likewise, ints may be stored as doubles.
    // If the value is numeric and has no decimal part, convert to int.
    if (value is num && value.toInt() == value) {
      return value.toInt() as T;
    }
  }
  return value as T;
}

dynamic getJsonField(final dynamic response, final String jsonPath,
    {final bool isForList = false}) {
  final Iterable<JsonPathMatch> field = JsonPath(jsonPath).read(response);
  if (field.isEmpty) {
    return null;
  }
  if (field.length > 1) {
    return field.map((final f) => f.value).toList();
  }
  final Object? value = field.first.value;
  if (isForList) {
    return value is! Iterable
        ? [value]
        : (value is List ? value : value.toList());
  }
  return value;
}

Rect? getWidgetBoundingBox(final BuildContext context) {
  try {
    final renderBox = context.findRenderObject() as RenderBox?;
    return renderBox!.localToGlobal(Offset.zero) & renderBox.size;
  } on Exception catch (_) {
    return null;
  }
}

bool get isAndroid => !kIsWeb && Platform.isAndroid;

bool get isiOS => !kIsWeb && Platform.isIOS;

bool get isWeb => kIsWeb;

const kBreakpointSmall = 479.0;
const kBreakpointMedium = 767.0;
const kBreakpointLarge = 991.0;

bool isMobileWidth(final BuildContext context) =>
    MediaQuery.sizeOf(context).width < kBreakpointSmall;

bool responsiveVisibility({
  required final BuildContext context,
  final bool phone = true,
  final bool tablet = true,
  final bool tabletLandscape = true,
  final bool desktop = true,
}) {
  final double width = MediaQuery.sizeOf(context).width;
  if (width < kBreakpointSmall) {
    return phone;
  } else if (width < kBreakpointMedium) {
    return tablet;
  } else if (width < kBreakpointLarge) {
    return tabletLandscape;
  } else {
    return desktop;
  }
}

const kTextValidatorUsernameRegex = r"^[a-zA-Z][a-zA-Z0-9_-]{2,16}$";
// https://stackoverflow.com/a/201378
const kTextValidatorEmailRegex =
    "^(?:[a-zA-Z0-9!#\$%&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#\$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?|\\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-zA-Z0-9-]*[a-zA-Z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])\$";
const kTextValidatorWebsiteRegex =
    r"(https?:\/\/)?(www\.)[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,10}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)|(https?:\/\/)?(www\.)?(?!ww)[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,10}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)";

extension FFTextEditingControllerExt on TextEditingController? {
  String get text => this == null ? "" : this!.text;

  set text(final String newText) => this?.text = newText;
}

extension IterableExt<T> on Iterable<T> {
  List<T> sortedList<S extends Comparable>(
      {final S Function(T)? keyOf, final bool desc = false}) {
    final List<T> sortedAscending = toList()
      ..sort(keyOf == null
          ? null
          : ((final a, final b) => keyOf(a).compareTo(keyOf(b))));
    if (desc) {
      return sortedAscending.reversed.toList();
    }
    return sortedAscending;
  }

  List<S> mapIndexed<S>(final S Function(int, T) func) => toList()
      .asMap()
      .map((final index, final value) => MapEntry(index, func(index, value)))
      .values
      .toList();
}

extension StringDocRef on String {
  DocumentReference get ref => FirebaseFirestore.instance.doc(this);
}

void showSnackbar(
  final BuildContext context,
  final String message, {
  final bool loading = false,
  final int duration = 4,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          if (loading)
            const Padding(
              padding: EdgeInsetsDirectional.only(end: 10),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          Text(message),
        ],
      ),
      duration: Duration(seconds: duration),
    ),
  );
}

extension FFStringExt on String {
  String maybeHandleOverflow(
          {final int? maxChars, final String replacement = ""}) =>
      maxChars != null && length > maxChars
          ? replaceRange(maxChars, null, replacement)
          : this;
}

extension ListFilterExt<T> on Iterable<T?> {
  List<T> get withoutNulls =>
      where((final s) => s != null).map((final e) => e!).toList();
}

extension MapFilterExtensions<T> on Map<String, T?> {
  Map<String, T> get withoutNulls => Map.fromEntries(
        entries
            .where((final e) => e.value != null)
            .map((final e) => MapEntry(e.key, e.value as T)),
      );
}

extension MapListContainsExt on List<dynamic> {
  bool containsMap(final dynamic map) => map is Map
      ? any((final e) =>
          e is Map && const DeepCollectionEquality().equals(e, map))
      : contains(map);
}

extension ListDivideExt<T extends Widget> on Iterable<T> {
  Iterable<MapEntry<int, Widget>> get enumerate => toList().asMap().entries;

  List<Widget> divide(final Widget t, {final bool Function(int)? filterFn}) =>
      isEmpty
          ? []
          : (enumerate
              .map((final e) =>
                  [e.value, if (filterFn == null || filterFn(e.key)) t])
              .expand((final i) => i)
              .toList()
            ..removeLast());

  List<Widget> around(final Widget t) => addToStart(t).addToEnd(t);

  List<Widget> addToStart(final Widget t) =>
      enumerate.map((final e) => e.value).toList()..insert(0, t);

  List<Widget> addToEnd(final Widget t) =>
      enumerate.map((final e) => e.value).toList()..add(t);

  List<Padding> paddingTopEach(final double val) =>
      map((final w) => Padding(padding: EdgeInsets.only(top: val), child: w))
          .toList();
}

extension StatefulWidgetExtensions on State<StatefulWidget> {
  /// Check if the widget exist before safely setting state.
  void safeSetState(final VoidCallback fn) {
    if (mounted) {
      // ignore: invalid_use_of_protected_member
      setState(fn);
    }
  }
}

// For iOS 16 and below, set the status bar color to match the app's theme.
// https://github.com/flutter/flutter/issues/41067
Brightness? _lastBrightness;

void fixStatusBarOniOS16AndBelow(final BuildContext context) {
  if (!isiOS) {
    return;
  }
  final Brightness brightness = Theme.of(context).brightness;
  if (_lastBrightness != brightness) {
    _lastBrightness = brightness;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: brightness,
        systemStatusBarContrastEnforced: true,
      ),
    );
  }
}

extension ColorOpacityExt on Color {
  Color applyAlpha(final double val) => withValues(alpha: val);
}

String roundTo(final double value, final int decimalPoints) {
  final num power = pow(10, decimalPoints);
  return ((value * power).round() / power).toString();
}

double computeGradientAlignmentX(final double evaluatedAngle) {
  double angle = evaluatedAngle % 360;
  final double rads = angle * pi / 180;
  double x;
  if (angle < 45 || angle > 315) {
    x = sin(2 * rads);
  } else if (45 <= angle && angle <= 135) {
    x = 1;
  } else if (135 <= angle && angle <= 225) {
    x = sin(-2 * rads);
  } else {
    x = -1;
  }
  return double.parse(roundTo(x, 2));
}

double computeGradientAlignmentY(final double evaluatedAngle) {
  double angle = evaluatedAngle % 360;
  final double rads = angle * pi / 180;
  double y;
  if (angle < 45 || angle > 315) {
    y = -1;
  } else if (45 <= angle && angle <= 135) {
    y = sin(-2 * rads);
  } else if (135 <= angle && angle <= 225) {
    y = 1;
  } else {
    y = sin(2 * rads);
  }
  return double.parse(roundTo(y, 2));
}

extension ListUniqueExt<T> on Iterable<T> {
  List<T> unique(final dynamic Function(T) getKey) {
    var distinctSet = <dynamic>{};
    var distinctList = <T>[];
    for (final item in this) {
      if (distinctSet.add(getKey(item))) {
        distinctList.add(item);
      }
    }
    return distinctList;
  }
}
