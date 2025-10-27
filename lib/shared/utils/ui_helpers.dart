import "package:flutter/material.dart";
import "package:rainvu/core/utils/snackbar_service.dart";

void showSnackbar(
  final String message, {
  final MessageType type = MessageType.info,
  final int duration = 4,
}) {
  SnackbarService.instance.showSnackBar(
    message,
    type: type,
    duration: Duration(seconds: duration),
  );
}

/// A helper function to show a standardized date and time picker sequence.
///
/// It first presents a [showDatePicker], and if a date is selected, it follows
/// up with a [showTimePicker]. The results are combined into a single [DateTime]
/// object.
///
/// For accessibility, this function checks the device's text scale factor. If it
/// exceeds a certain threshold, the pickers default to keyboard input mode to
/// prevent UI overflow issues with large fonts.
Future<DateTime?> showAppDateTimePicker(
  final BuildContext context, {
  required final DateTime initialDate,
  required final DateTime firstDate,
  required final DateTime lastDate,
  final bool? timePickerIsInputOnly,
}) async {
  // Determine if large text scaling is active to switch to input mode.
  final bool useInputMode = MediaQuery.textScalerOf(context).scale(1) > 1.4;

  final DatePickerEntryMode datePickerEntryMode = useInputMode
      ? DatePickerEntryMode.input
      : DatePickerEntryMode.calendar;
  final TimePickerEntryMode timePickerEntryMode =
      (timePickerIsInputOnly ?? false)
      ? TimePickerEntryMode.inputOnly
      : (useInputMode ? TimePickerEntryMode.input : TimePickerEntryMode.dial);

  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    initialEntryMode: datePickerEntryMode,
  );

  if (pickedDate == null) {
    // User canceled the date picker
    return null;
  }

  // Check if context is still valid before showing the time picker
  if (!context.mounted) {
    return null;
  }

  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initialDate),
    initialEntryMode: timePickerEntryMode,
  );

  if (pickedTime == null) {
    // User canceled the time picker
    return null;
  }

  return DateTime(
    pickedDate.year,
    pickedDate.month,
    pickedDate.day,
    pickedTime.hour,
    pickedTime.minute,
  );
}
