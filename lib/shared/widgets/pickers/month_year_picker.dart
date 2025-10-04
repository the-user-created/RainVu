import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";

/// Shows a modal bottom sheet for selecting a month and year.
///
/// Returns a [DateTime] representing the first day of the selected month,
/// or `null` if the user cancels.
Future<DateTime?> showMonthYearPicker(
  final BuildContext context, {
  required final DateTime initialDate,
  final DateTime? firstDate,
  final DateTime? lastDate,
}) async => showModalBottomSheet<DateTime>(
  context: context,
  isScrollControlled: true,
  backgroundColor: Theme.of(context).colorScheme.surface,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
  ),
  builder: (final context) => _MonthYearPicker(
    initialDate: initialDate,
    firstDate: firstDate ?? DateTime(2000),
    lastDate: lastDate ?? DateTime(2100),
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
  late FixedExtentScrollController _monthController;

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

    // Month index is 0-based (January is 0).
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

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Text(l10n.selectMonthTitle, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Row(
                children: [_buildMonthPicker(theme), _buildYearPicker(theme)],
              ),
            ),
            const SizedBox(height: 24),
            _buildActionButtons(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthPicker(final ThemeData theme) {
    final List<String> months = List.generate(
      12,
      (final index) => DateFormat.MMMM().format(DateTime(0, index + 1)),
    );

    return Expanded(
      child: CupertinoPicker(
        scrollController: _monthController,
        itemExtent: 40,
        magnification: 1.2,
        useMagnifier: true,
        onSelectedItemChanged: (final index) {
          setState(() {
            _selectedMonth = index + 1;
          });
        },
        children: months
            .map(
              (final month) => Center(
                child: Text(month, style: theme.textTheme.titleMedium),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildYearPicker(final ThemeData theme) {
    final int yearCount = widget.lastDate.year - widget.firstDate.year + 1;

    return Expanded(
      child: CupertinoPicker(
        scrollController: _yearController,
        itemExtent: 40,
        magnification: 1.2,
        useMagnifier: true,
        onSelectedItemChanged: (final index) {
          setState(() {
            _selectedYear = widget.firstDate.year + index;
          });
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

  Widget _buildActionButtons(final AppLocalizations l10n) => Row(
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
          final DateTime result = DateTime(_selectedYear, _selectedMonth);
          Navigator.of(context).pop(result);
        },
        label: l10n.okButtonLabel,
        size: AppButtonSize.small,
      ),
    ],
  );
}
