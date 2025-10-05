import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/widgets/buttons/app_icon_button.dart";
import "package:rain_wise/shared/widgets/sheets/interactive_sheet.dart";

/// Shows a modal bottom sheet for selecting a month and year.
///
/// Returns a [DateTime] representing the first day of the selected month,
/// or `null` if the user cancels.
Future<DateTime?> showMonthYearPicker(
  final BuildContext context, {
  required final DateTime initialDate,
  required final DateTime firstDate,
  required final DateTime lastDate,
}) async => showModalBottomSheet<DateTime>(
  context: context,
  isScrollControlled: true,
  builder: (final context) => _MonthYearPicker(
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  ),
);

class _MonthYearPicker extends StatefulWidget {
  const _MonthYearPicker({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  State<_MonthYearPicker> createState() => _MonthYearPickerState();
}

class _MonthYearPickerState extends State<_MonthYearPicker> {
  late int _selectedYear;
  late int _selectedMonth;
  late FixedExtentScrollController _yearController;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialDate.year;
    _selectedMonth = widget.initialDate.month;

    // Calculate the initial index for the year controller.
    final int initialYearIndex = _selectedYear - widget.firstDate.year;
    _yearController = FixedExtentScrollController(
      initialItem: initialYearIndex,
    );
  }

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    // When the year changes, clamp the selected month to the valid range for that year.
    final int firstValidMonth = (_selectedYear == widget.firstDate.year)
        ? widget.firstDate.month
        : 1;
    final int lastValidMonth = (_selectedYear == widget.lastDate.year)
        ? widget.lastDate.month
        : 12;
    _selectedMonth = _selectedMonth.clamp(firstValidMonth, lastValidMonth);

    return InteractiveSheet(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(l10n.selectMonthTitle),
          AppIconButton(
            icon: const Icon(Icons.check_circle_outline),
            tooltip: l10n.okButtonLabel,
            color: theme.colorScheme.primary,
            iconSize: 28,
            onPressed: () {
              final DateTime result = DateTime(_selectedYear, _selectedMonth);
              Navigator.of(context).pop(result);
            },
          ),
        ],
      ),
      child: SizedBox(
        height: 200,
        child: Row(
          children: [_buildMonthPicker(theme), _buildYearPicker(theme)],
        ),
      ),
    );
  }

  Widget _buildMonthPicker(final ThemeData theme) => Expanded(
    child: _MonthPickerWrapper(
      key: ValueKey(_selectedYear),
      selectedYear: _selectedYear,
      selectedMonth: _selectedMonth,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      onChanged: (final newMonth) {
        if (newMonth != _selectedMonth) {
          setState(() => _selectedMonth = newMonth);
        }
      },
    ),
  );

  Widget _buildYearPicker(final ThemeData theme) {
    final int yearCount = widget.lastDate.year - widget.firstDate.year + 1;

    return Expanded(
      child: CupertinoPicker(
        scrollController: _yearController,
        itemExtent: 40,
        magnification: 1.2,
        useMagnifier: true,
        onSelectedItemChanged: (final index) {
          final int newYear = widget.firstDate.year + index;
          if (newYear != _selectedYear) {
            setState(() {
              _selectedYear = newYear;
            });
          }
        },
        children: List.generate(yearCount, (final index) {
          final int year = widget.firstDate.year + index;
          return Center(
            child: Text(year.toString(), style: theme.textTheme.titleMedium),
          );
        }),
      ),
    );
  }
}

/// A stateful wrapper for the month `CupertinoPicker`.
///
/// This widget manages its own `FixedExtentScrollController` to ensure it is
/// correctly initialized and disposed when the list of available months changes
/// (which happens when the year changes).
class _MonthPickerWrapper extends StatefulWidget {
  const _MonthPickerWrapper({
    required this.selectedYear,
    required this.selectedMonth,
    required this.firstDate,
    required this.lastDate,
    required this.onChanged,
    super.key,
  });

  final int selectedYear;
  final int selectedMonth;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<int> onChanged;

  @override
  State<_MonthPickerWrapper> createState() => __MonthPickerWrapperState();
}

class __MonthPickerWrapperState extends State<_MonthPickerWrapper> {
  late FixedExtentScrollController _monthController;

  @override
  void initState() {
    super.initState();
    final int firstMonth = (widget.selectedYear == widget.firstDate.year)
        ? widget.firstDate.month
        : 1;
    final int initialItem = widget.selectedMonth - firstMonth;
    _monthController = FixedExtentScrollController(initialItem: initialItem);
  }

  @override
  void dispose() {
    _monthController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final int firstMonth = (widget.selectedYear == widget.firstDate.year)
        ? widget.firstDate.month
        : 1;
    final int lastMonth = (widget.selectedYear == widget.lastDate.year)
        ? widget.lastDate.month
        : 12;

    final List<String> months = List.generate(
      lastMonth - firstMonth + 1,
      (final index) =>
          DateFormat.MMMM().format(DateTime(0, firstMonth + index)),
    );

    return CupertinoPicker(
      scrollController: _monthController,
      itemExtent: 40,
      magnification: 1.2,
      useMagnifier: true,
      onSelectedItemChanged: (final index) {
        widget.onChanged(firstMonth + index);
      },
      children: months
          .map(
            (final month) =>
                Center(child: Text(month, style: theme.textTheme.titleMedium)),
          )
          .toList(),
    );
  }
}
