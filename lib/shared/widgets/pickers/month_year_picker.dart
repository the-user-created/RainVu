import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";
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

/// Enum to manage which view is currently displayed in the picker.
enum _PickerView { year, decade }

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
  late DateTime _selectedDate;
  late DateTime _displayedDate;
  late _PickerView _currentView;

  late final PageController _yearPageController;
  late final PageController _decadePageController;
  late final int _firstDecadeStartYear;
  late final int _lastDecadeStartYear;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime(widget.initialDate.year, widget.initialDate.month);
    _displayedDate = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
    );
    _currentView = _PickerView.year;

    // Year PageView setup
    final int initialYearPage = widget.initialDate.year - widget.firstDate.year;
    _yearPageController = PageController(initialPage: initialYearPage);

    // Decade PageView setup
    _firstDecadeStartYear = (widget.firstDate.year ~/ 10) * 10;
    _lastDecadeStartYear = (widget.lastDate.year ~/ 10) * 10;
    final int initialDecadeStartYear = (widget.initialDate.year ~/ 10) * 10;
    final int initialDecadePage =
        (initialDecadeStartYear - _firstDecadeStartYear) ~/ 10;
    _decadePageController = PageController(initialPage: initialDecadePage);
  }

  @override
  void dispose() {
    _yearPageController.dispose();
    _decadePageController.dispose();
    super.dispose();
  }

  bool get _canGoPrevious {
    if (_currentView == _PickerView.year) {
      return _displayedDate.year > widget.firstDate.year;
    } else {
      final int currentDecadeStartYear = (_displayedDate.year ~/ 10) * 10;
      return currentDecadeStartYear > _firstDecadeStartYear;
    }
  }

  bool get _canGoNext {
    if (_currentView == _PickerView.year) {
      return _displayedDate.year < widget.lastDate.year;
    } else {
      final int currentDecadeStartYear = (_displayedDate.year ~/ 10) * 10;
      return currentDecadeStartYear < _lastDecadeStartYear;
    }
  }

  void _handleViewChange() {
    setState(() {
      if (_currentView == _PickerView.year) {
        _currentView = _PickerView.decade;
        final int targetDecadePage =
            ((_displayedDate.year ~/ 10) * 10 - _firstDecadeStartYear) ~/ 10;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_decadePageController.hasClients) {
            _decadePageController.jumpToPage(targetDecadePage);
          }
        });
      } else {
        _currentView = _PickerView.year;
        final int targetYearPage = _displayedDate.year - widget.firstDate.year;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_yearPageController.hasClients) {
            _yearPageController.jumpToPage(targetYearPage);
          }
        });
      }
    });
  }

  void _handleYearSelected(final int year) {
    setState(() {
      _displayedDate = DateTime(year, _displayedDate.month);
      _currentView = _PickerView.year;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final int targetPage = year - widget.firstDate.year;
      if (_yearPageController.hasClients &&
          _yearPageController.page?.round() != targetPage) {
        _yearPageController.jumpToPage(targetPage);
      }
    });
  }

  void _handleMonthSelected(final int month) {
    setState(() {
      _selectedDate = DateTime(_displayedDate.year, month);
    });
  }

  void _handlePrevious() {
    if (!_canGoPrevious) {
      return;
    }
    (_currentView == _PickerView.year
            ? _yearPageController
            : _decadePageController)
        .previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
  }

  void _handleNext() {
    if (!_canGoNext) {
      return;
    }
    (_currentView == _PickerView.year
            ? _yearPageController
            : _decadePageController)
        .nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
  }

  @override
  Widget build(final BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final int yearCount = widget.lastDate.year - widget.firstDate.year + 1;
    final int decadeCount =
        ((_lastDecadeStartYear - _firstDecadeStartYear) ~/ 10) + 1;

    final Widget yearPicker = PageView.builder(
      key: const ValueKey("year_picker"),
      controller: _yearPageController,
      itemCount: yearCount,
      onPageChanged: (final index) {
        final int newYear = widget.firstDate.year + index;
        if (_displayedDate.year != newYear) {
          setState(() {
            _displayedDate = DateTime(newYear, _displayedDate.month);
          });
        }
      },
      itemBuilder: (final context, final index) {
        final int year = widget.firstDate.year + index;
        return _YearView(
          year: year,
          selectedDate: _selectedDate,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          onMonthSelected: _handleMonthSelected,
        );
      },
    );

    final Widget decadePicker = PageView.builder(
      key: const ValueKey("decade_picker"),
      controller: _decadePageController,
      itemCount: decadeCount,
      onPageChanged: (final index) {
        final int newStartYear = _firstDecadeStartYear + (index * 10);
        if ((_displayedDate.year ~/ 10) * 10 != newStartYear) {
          setState(() {
            _displayedDate = DateTime(newStartYear, _displayedDate.month);
          });
        }
      },
      itemBuilder: (final context, final index) {
        final int decadeStartYear = _firstDecadeStartYear + (index * 10);
        return _DecadeView(
          decadeStartYear: decadeStartYear,
          selectedDate: _selectedDate,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          onYearSelected: _handleYearSelected,
        );
      },
    );

    return InteractiveSheet(
      title: Text(l10n.selectMonthTitle),
      titleAlign: TextAlign.start,
      actions: [
        Expanded(
          child: AppButton(
            label: l10n.cancelButtonLabel,
            style: AppButtonStyle.outline,
            isExpanded: true,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppButton(
            label: l10n.applyButtonLabel,
            isExpanded: true,
            onPressed: () => Navigator.of(context).pop(_selectedDate),
          ),
        ),
      ],
      child: SizedBox(
        height: 340,
        child: Column(
          children: [
            _PickerHeader(
              displayedDate: _displayedDate,
              currentView: _currentView,
              onPrevious: _handlePrevious,
              onNext: _handleNext,
              onViewSwitch: _handleViewChange,
              canGoPrevious: _canGoPrevious,
              canGoNext: _canGoNext,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (final child, final animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: _currentView == _PickerView.year
                    ? yearPicker
                    : decadePicker,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerHeader extends StatelessWidget {
  const _PickerHeader({
    required this.displayedDate,
    required this.currentView,
    required this.onPrevious,
    required this.onNext,
    required this.onViewSwitch,
    required this.canGoPrevious,
    required this.canGoNext,
  });

  final DateTime displayedDate;
  final _PickerView currentView;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onViewSwitch;
  final bool canGoPrevious;
  final bool canGoNext;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final AppLocalizations l10n = AppLocalizations.of(context);

    String title;
    if (currentView == _PickerView.year) {
      title = displayedDate.year.toString();
    } else {
      final int startDecade = (displayedDate.year ~/ 10) * 10;
      final int endDecade = startDecade + 9;
      title = "$startDecade - $endDecade";
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppIconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: canGoPrevious ? onPrevious : null,
          tooltip: l10n.previousButtonTooltip,
        ),
        TextButton(
          onPressed: onViewSwitch,
          style: TextButton.styleFrom(
            textStyle: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          child: Text(title),
        ),
        AppIconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: canGoNext ? onNext : null,
          tooltip: l10n.nextButtonTooltip,
        ),
      ],
    );
  }
}

class _YearView extends StatelessWidget {
  const _YearView({
    required this.year,
    required this.selectedDate,
    required this.firstDate,
    required this.lastDate,
    required this.onMonthSelected,
  });

  final int year;
  final DateTime selectedDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<int> onMonthSelected;

  @override
  Widget build(final BuildContext context) => GridView.builder(
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.symmetric(horizontal: 4),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      childAspectRatio: 2.2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
    ),
    itemCount: 12,
    itemBuilder: (final context, final index) {
      final int month = index + 1;
      final DateTime currentDate = DateTime(year, month);
      final bool isSelected =
          year == selectedDate.year && month == selectedDate.month;
      final bool isDisabled =
          currentDate.isAfter(lastDate) ||
          DateTime(
            currentDate.year,
            currentDate.month + 1,
            0,
          ).isBefore(firstDate);

      return _MonthCell(
        month: month,
        isSelected: isSelected,
        isDisabled: isDisabled,
        onTap: () => onMonthSelected(month),
      );
    },
  );
}

class _MonthCell extends StatelessWidget {
  const _MonthCell({
    required this.month,
    required this.isSelected,
    required this.isDisabled,
    required this.onTap,
  });

  final int month;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final String monthText = DateFormat.MMM().format(DateTime(0, month));

    Color backgroundColor = Colors.transparent;
    Color textColor = colorScheme.onSurface;

    if (isSelected) {
      backgroundColor = colorScheme.secondary;
      textColor = colorScheme.onSecondary;
    } else {
      backgroundColor = colorScheme.surfaceContainerHighest;
    }

    if (isDisabled) {
      textColor = colorScheme.onSurface.withValues(alpha: 0.38);
    }

    return InkWell(
      onTap: isDisabled ? null : onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            monthText,
            style: textTheme.bodyLarge?.copyWith(
              color: textColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _DecadeView extends StatelessWidget {
  const _DecadeView({
    required this.decadeStartYear,
    required this.selectedDate,
    required this.firstDate,
    required this.lastDate,
    required this.onYearSelected,
  });

  final int decadeStartYear;
  final DateTime selectedDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<int> onYearSelected;

  @override
  Widget build(final BuildContext context) {
    final List<int> years = List.generate(
      10,
      (final index) => decadeStartYear + index,
    );

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: years.length,
      itemBuilder: (final context, final index) {
        final int year = years[index];
        final bool isSelected = year == selectedDate.year;
        final bool isDisabled = year < firstDate.year || year > lastDate.year;

        return _YearCell(
          year: year,
          isSelected: isSelected,
          isDisabled: isDisabled,
          onTap: () => onYearSelected(year),
        );
      },
    );
  }
}

class _YearCell extends StatelessWidget {
  const _YearCell({
    required this.year,
    required this.isSelected,
    required this.isDisabled,
    required this.onTap,
  });

  final int year;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    Color backgroundColor = Colors.transparent;
    Color textColor = colorScheme.onSurface;

    if (isSelected) {
      backgroundColor = colorScheme.secondary;
      textColor = colorScheme.onSecondary;
    } else {
      backgroundColor = colorScheme.surfaceContainerHighest;
    }

    if (isDisabled) {
      textColor = colorScheme.onSurface.withValues(alpha: 0.38);
    }

    return InkWell(
      onTap: isDisabled ? null : onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            year.toString(),
            style: textTheme.bodyLarge?.copyWith(
              color: textColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
