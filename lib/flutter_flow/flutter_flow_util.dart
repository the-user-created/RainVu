import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:timeago/timeago.dart" as timeago;

export "package:intl/intl.dart";

export "../app_constants.dart";

T valueOrDefault<T>(final T? value, final T defaultValue) =>
    (value is String && value.isEmpty) || value == null ? defaultValue : value;

void _setTimeagoLocales() {
  timeago.setLocaleMessages("en", timeago.EnMessages());
  timeago.setLocaleMessages("en_short", timeago.EnShortMessages());
}

String dateTimeFormat(
  final String format,
  final DateTime? dateTime, {
  final String? locale,
}) {
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
          }),
        ),
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
          }),
        ),
      ),
      timePickerTheme: baseTheme.timePickerTheme.copyWith(
        backgroundColor: pickerBackgroundColor,
        hourMinuteTextColor: pickerForegroundColor,
        dialHandColor: selectedDateTimeBackgroundColor,
        dialTextColor: WidgetStateColor.resolveWith(
          (final states) => states.contains(WidgetState.selected)
              ? selectedDateTimeForegroundColor
              : pickerForegroundColor,
        ),
        dayPeriodBorderSide: BorderSide(
          color: pickerForegroundColor,
        ),
        dayPeriodTextColor: WidgetStateColor.resolveWith(
          (final states) => states.contains(WidgetState.selected)
              ? selectedDateTimeForegroundColor
              : pickerForegroundColor,
        ),
        dayPeriodColor: WidgetStateColor.resolveWith(
          (final states) => states.contains(WidgetState.selected)
              ? selectedDateTimeBackgroundColor
              : Colors.transparent,
        ),
        entryModeIconColor: pickerForegroundColor,
      ),
    ),
    child: child,
  );
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

extension ListDivideExt<T extends Widget> on Iterable<T> {
  Iterable<MapEntry<int, Widget>> get enumerate => toList().asMap().entries;

  List<Widget> divide(final Widget t, {final bool Function(int)? filterFn}) =>
      isEmpty
          ? []
          : (enumerate
              .map(
                (final e) =>
                    [e.value, if (filterFn == null || filterFn(e.key)) t],
              )
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

extension ColorOpacityExt on Color {
  Color applyAlpha(final double val) => withValues(alpha: val);
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
