import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";

/// Shows a modal bottom sheet for selecting a date range.
///
/// Returns a [DateTimeRange] representing the selected start and end dates,
/// or `null` if the user cancels.
Future<DateTimeRange?> showDateRangePickerModal(
  final BuildContext context, {
  required final DateTimeRange initialDateRange,
  required final DateTime firstDate,
  required final DateTime lastDate,
}) async => showModalBottomSheet<DateTimeRange>(
  context: context,
  isScrollControlled: true,
  backgroundColor: Theme.of(context).colorScheme.surface,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
  ),
  builder: (final context) => _DateRangePickerModal(
    initialDateRange: initialDateRange,
    firstDate: firstDate,
    lastDate: lastDate,
  ),
);

/// Enum for managing which date is being selected
enum _DateSelectionMode { start, end }

class _DateRangePickerModal extends StatefulWidget {
  const _DateRangePickerModal({
    required this.initialDateRange,
    required this.firstDate,
    required this.lastDate,
  });

  final DateTimeRange initialDateRange;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  State<_DateRangePickerModal> createState() => _DateRangePickerModalState();
}

class _DateRangePickerModalState extends State<_DateRangePickerModal> {
  _DateSelectionMode _selectionMode = _DateSelectionMode.start;
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    // Clamp the initial start and end dates to be within the allowed range.
    // This prevents assertion errors if the provided initialDateRange is
    // outside the bounds of firstDate and lastDate.
    DateTime safeStart = widget.initialDateRange.start;
    if (safeStart.isAfter(widget.lastDate)) {
      safeStart = widget.lastDate;
    }
    if (safeStart.isBefore(widget.firstDate)) {
      safeStart = widget.firstDate;
    }

    DateTime safeEnd = widget.initialDateRange.end;
    if (safeEnd.isAfter(widget.lastDate)) {
      safeEnd = widget.lastDate;
    }
    if (safeEnd.isBefore(widget.firstDate)) {
      safeEnd = widget.firstDate;
    }

    // After clamping, ensure the start date is still not after the end date.
    if (safeStart.isAfter(safeEnd)) {
      safeEnd = safeStart;
    }

    _startDate = safeStart;
    _endDate = safeEnd;
  }

  void _onDateSelected(final DateTime newDate) {
    setState(() {
      if (_selectionMode == _DateSelectionMode.start) {
        _startDate = newDate;
        // If the new start date is after the current end date, move the end date forward.
        if (_startDate.isAfter(_endDate)) {
          _endDate = _startDate;
        }
        // Automatically switch to picking the end date
        _selectionMode = _DateSelectionMode.end;
      } else {
        _endDate = newDate;
        // If the new end date is before the current start date, move the start date back.
        if (_endDate.isBefore(_startDate)) {
          _startDate = _endDate;
        }
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle and Title
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.selectDateRangeTitle,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),

              // Start and End Date Display/Selectors
              _DateSelector(
                startDate: _startDate,
                endDate: _endDate,
                selectionMode: _selectionMode,
                onModeChanged: (final mode) =>
                    setState(() => _selectionMode = mode),
              ),
              const SizedBox(height: 16),

              // Calendar
              CalendarDatePicker(
                key: ValueKey(_selectionMode),
                initialDate: _selectionMode == _DateSelectionMode.start
                    ? _startDate
                    : _endDate,
                firstDate: widget.firstDate,
                lastDate: widget.lastDate,
                onDateChanged: _onDateSelected,
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                    onPressed: () => Navigator.of(context).pop(),
                    label: l10n.cancelButtonLabel,
                    style: AppButtonStyle.outline,
                    size: AppButtonSize.small,
                  ),
                  const SizedBox(width: 12),
                  AppButton(
                    onPressed: () {
                      final DateTimeRange result = DateTimeRange(
                        start: _startDate,
                        end: _endDate,
                      );
                      Navigator.of(context).pop(result);
                    },
                    label: l10n.applyButtonLabel,
                    size: AppButtonSize.small,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateSelector extends StatelessWidget {
  const _DateSelector({
    required this.startDate,
    required this.endDate,
    required this.selectionMode,
    required this.onModeChanged,
  });

  final DateTime startDate;
  final DateTime endDate;
  final _DateSelectionMode selectionMode;
  final ValueChanged<_DateSelectionMode> onModeChanged;

  @override
  Widget build(final BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: _DateBox(
            label: l10n.startDateLabel,
            date: startDate,
            isSelected: selectionMode == _DateSelectionMode.start,
            onTap: () => onModeChanged(_DateSelectionMode.start),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _DateBox(
            label: l10n.endDateLabel,
            date: endDate,
            isSelected: selectionMode == _DateSelectionMode.end,
            onTap: () => onModeChanged(_DateSelectionMode.end),
          ),
        ),
      ],
    );
  }
}

class _DateBox extends StatelessWidget {
  const _DateBox({
    required this.label,
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final String formattedDate = DateFormat.yMMMd().format(date);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.secondary.withValues(alpha: 0.1)
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colorScheme.secondary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? colorScheme.secondary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              formattedDate,
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
