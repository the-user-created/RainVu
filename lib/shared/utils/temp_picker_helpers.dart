import "package:flutter/material.dart";

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
      return pickerForegroundColor.withValues(alpha: 0.60);
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
      disabledColor: pickerForegroundColor.withValues(alpha: 0.3),
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
              return actionButtonForegroundColor.withValues(alpha: 0.04);
            }
            if (states.contains(WidgetState.focused) ||
                states.contains(WidgetState.pressed)) {
              return actionButtonForegroundColor.withValues(alpha: 0.12);
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
              return actionButtonForegroundColor.withValues(alpha: 0.04);
            }
            if (states.contains(WidgetState.focused) ||
                states.contains(WidgetState.pressed)) {
              return actionButtonForegroundColor.withValues(alpha: 0.12);
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
