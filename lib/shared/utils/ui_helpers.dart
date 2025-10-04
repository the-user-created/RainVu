import "package:flutter/material.dart";

void showSnackbar(
  final BuildContext context,
  final String message, {
  final bool loading = false,
  final int duration = 4,
}) {
  final ThemeData theme = Theme.of(context);
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          if (loading)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 10),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: theme.colorScheme.onInverseSurface,
                ),
              ),
            ),
          Expanded(child: Text(message)),
        ],
      ),
      duration: Duration(seconds: duration),
    ),
  );
}

/// A helper function to show a standardized date and time picker sequence.
///
/// It first presents a [showDatePicker], and if a date is selected, it follows
/// up with a [showTimePicker]. The results are combined into a single [DateTime]
/// object. This centralizes the logic and ensures a consistent user flow for
/// picking a full date and time.
Future<DateTime?> showAppDateTimePicker(
  final BuildContext context, {
  required final DateTime initialDate,
  required final DateTime firstDate,
  required final DateTime lastDate,
}) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
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
