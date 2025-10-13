import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:intl/intl.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/utils/adaptive_ui_helpers.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";
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
}) async => showAdaptiveSheet<DateTime>(
  context: context,
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

  late final FixedExtentScrollController _yearController;
  late final FixedExtentScrollController _monthController;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialDate.year;
    _selectedMonth = widget.initialDate.month;

    _yearController = FixedExtentScrollController(
      initialItem: _selectedYear - widget.firstDate.year,
    );
    _monthController = FixedExtentScrollController(
      initialItem: _selectedMonth - 1,
    );
  }

  @override
  void dispose() {
    _yearController.dispose();
    _monthController.dispose();
    super.dispose();
  }

  void _onYearChanged(final int index) {
    setState(() {
      _selectedYear = widget.firstDate.year + index;

      // If the new year makes the currently selected month invalid, adjust it.
      final DateTime newDate = DateTime(_selectedYear, _selectedMonth);
      if (newDate.isBefore(widget.firstDate)) {
        _selectedMonth = widget.firstDate.month;
        _monthController.animateToItem(
          _selectedMonth - 1,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      } else if (newDate.isAfter(widget.lastDate)) {
        _selectedMonth = widget.lastDate.month;
        _monthController.animateToItem(
          _selectedMonth - 1,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onMonthChanged(final int index) {
    final int newMonth = index + 1;
    final DateTime newDate = DateTime(_selectedYear, newMonth);
    // Prevent scrolling to a disabled month
    if (newDate.isBefore(widget.firstDate) ||
        newDate.isAfter(widget.lastDate)) {
      _monthController.animateToItem(
        _selectedMonth - 1,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
      return;
    }
    setState(() {
      _selectedMonth = newMonth;
    });
  }

  @override
  Widget build(final BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextScaler textScaler = MediaQuery.textScalerOf(context);
    final double itemExtent = textScaler.scale(50);

    return InteractiveSheet(
      title: Text(l10n.selectMonthTitle),
      titleAlign: TextAlign.start,
      actions: [
        AppButton(
          label: l10n.applyButtonLabel,
          isExpanded: true,
          style: AppButtonStyle.secondary,
          onPressed: () => Navigator.of(
            context,
          ).pop(DateTime(_selectedYear, _selectedMonth)),
        ),
      ],
      child:
          SizedBox(
                height: 220,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: itemExtent,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    Row(
                      children: [
                        _buildYearPicker(itemExtent),
                        _buildMonthPicker(itemExtent),
                      ],
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(duration: 300.ms)
              .slideY(begin: 0.05, curve: Curves.easeOutCubic),
    );
  }

  Widget _buildYearPicker(final double itemExtent) => Expanded(
    child: ListWheelScrollView.useDelegate(
      controller: _yearController,
      itemExtent: itemExtent,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: _onYearChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        builder: (final context, final index) {
          final int year = widget.firstDate.year + index;
          final bool isSelected = year == _selectedYear;
          return _WheelItem(text: year.toString(), isSelected: isSelected);
        },
        childCount: widget.lastDate.year - widget.firstDate.year + 1,
      ),
    ),
  );

  Widget _buildMonthPicker(final double itemExtent) => Expanded(
    child: ListWheelScrollView.useDelegate(
      controller: _monthController,
      itemExtent: itemExtent,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: _onMonthChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        builder: (final context, final index) {
          final int month = index + 1;
          final String monthText = DateFormat.MMM().format(DateTime(0, month));
          final bool isSelected = month == _selectedMonth;

          final DateTime currentDate = DateTime(_selectedYear, month);
          final bool isDisabled =
              currentDate.isAfter(widget.lastDate) ||
              DateTime(
                currentDate.year,
                currentDate.month + 1,
                0,
              ).isBefore(widget.firstDate);

          return _WheelItem(
            text: monthText,
            isSelected: isSelected,
            isDisabled: isDisabled,
          );
        },
        childCount: 12,
      ),
    ),
  );
}

class _WheelItem extends StatelessWidget {
  const _WheelItem({
    required this.text,
    required this.isSelected,
    this.isDisabled = false,
  });

  final String text;
  final bool isSelected;
  final bool isDisabled;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;

    Color color = colorScheme.onSurface;
    if (isSelected) {
      color = colorScheme.primary;
    }
    if (isDisabled) {
      color = colorScheme.onSurface.withValues(alpha: 0.38);
    }

    return Center(
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: textTheme.titleLarge!.copyWith(
          color: color,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        child: Text(text),
      ),
    );
  }
}
