import "package:flutter/material.dart";
import "package:rainly/core/utils/extensions.dart";
import "package:rainly/l10n/app_localizations.dart";

/// Shows a Material Design date range picker.
///
/// Returns a [DateTimeRange] with the time component set to the start and end of the day,
/// or `null` if the user cancels.
Future<DateTimeRange?> showAppDateRangePicker(
  final BuildContext context, {
  required final DateTimeRange initialDateRange,
  required final DateTime firstDate,
  required final DateTime lastDate,
}) async {
  final AppLocalizations l10n = AppLocalizations.of(context);
  final ThemeData theme = Theme.of(context);

  // Helper to clamp a date within the allowed range.
  DateTime clampDate(
    final DateTime date,
    final DateTime min,
    final DateTime max,
  ) {
    if (date.isBefore(min)) {
      return min;
    }
    if (date.isAfter(max)) {
      return max;
    }
    return date;
  }

  DateTime clampedStart = clampDate(
    initialDateRange.start,
    firstDate,
    lastDate,
  );
  DateTime clampedEnd = clampDate(initialDateRange.end, firstDate, lastDate);

  if (clampedStart.isAfter(clampedEnd)) {
    clampedStart = clampedEnd;
  }

  final DateTimeRange validInitialRange = DateTimeRange(
    start: clampedStart,
    end: clampedEnd,
  );

  final DateTimeRange? pickedRange = await showDateRangePicker(
    context: context,
    initialDateRange: validInitialRange,
    firstDate: firstDate,
    lastDate: lastDate,
    helpText: l10n.selectDateRangeTitle.toUpperCase(),
    cancelText: l10n.cancelButtonLabel.toUpperCase(),
    confirmText: l10n.applyButtonLabel.toUpperCase(),
    saveText: l10n.saveButtonLabel.toUpperCase(),
    builder: (final context, final child) => Theme(
      data: theme.copyWith(
        datePickerTheme: theme.datePickerTheme.copyWith(
          headerHeadlineStyle: theme.textTheme.titleSmall,
        ),
      ),
      child: child!,
    ),
  );

  if (pickedRange != null) {
    // Adjust the time to cover the entire selected days for inclusive queries.
    return DateTimeRange(
      start: pickedRange.start.startOfDay,
      end: pickedRange.end.endOfDay,
    );
  }

  return null;
}
