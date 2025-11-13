import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rainvu/features/yearly_comparison/application/yearly_comparison_provider.dart";
import "package:rainvu/features/yearly_comparison/domain/yearly_comparison_data.dart";
import "package:rainvu/l10n/app_localizations.dart";
import "package:rainvu/shared/widgets/forms/app_choice_chips.dart";
import "package:rainvu/shared/widgets/forms/app_dropdown.dart";

class FiltersContent extends ConsumerWidget {
  const FiltersContent({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<ComparativeFilter> filterAsync = ref.watch(
      yearlyComparisonFilterProvider,
    );
    final AsyncValue<List<int>> availableYearsAsync = ref.watch(
      availableYearsProvider,
    );
    return filterAsync.when(
      loading: () => const SizedBox(height: 150),
      error: (final e, final s) =>
          Center(child: Text(l10n.yearlyComparisonFilterError)),
      data: (final filter) => availableYearsAsync.when(
        loading: () => const SizedBox(height: 150),
        error: (final e, final s) =>
            Center(child: Text(l10n.yearlyComparisonAvailableYearsError)),
        data: (final availableYears) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                l10n.yearlyComparisonSelectYearsTitle,
                style: textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 12),
            _YearSelectors(filter: filter, availableYears: availableYears),
            const SizedBox(height: 16),
            _ComparisonTypeSelector(filter: filter),
          ],
        ),
      ),
    );
  }
}

/// A responsive widget for selecting the two comparison years.
///
/// It displays dropdowns side-by-side on wider screens and stacks them
/// vertically on narrower screens or when text scaling is high.
class _YearSelectors extends ConsumerWidget {
  const _YearSelectors({required this.filter, required this.availableYears});

  final ComparativeFilter filter;
  final List<int> availableYears;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final YearlyComparisonFilterNotifier notifier = ref.read(
      yearlyComparisonFilterProvider.notifier,
    );

    Widget buildDropdown({
      required final int value,
      required final int otherValue,
      required final void Function(int?) onChanged,
    }) => AppDropdown<int>(
      value: value,
      items: availableYears
          .map(
            (final year) => DropdownMenuItem<int>(
              value: year,
              enabled: year != otherValue,
              child: Text(
                year.toString(),
                style: textTheme.bodyMedium?.copyWith(
                  color: year != otherValue
                      ? colorScheme.onSurface
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );

    final Widget year1Dropdown = buildDropdown(
      value: filter.year1,
      otherValue: filter.year2,
      onChanged: (final year) {
        if (year != null) {
          notifier.setYear1(year);
        }
      },
    );

    final Widget year2Dropdown = buildDropdown(
      value: filter.year2,
      otherValue: filter.year1,
      onChanged: (final year) {
        if (year != null) {
          notifier.setYear2(year);
        }
      },
    );

    return LayoutBuilder(
      builder: (final context, final constraints) {
        const double wrapThreshold = 340;

        if (constraints.maxWidth < wrapThreshold) {
          // Use a Column for small widths / large text
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              year1Dropdown,
              const SizedBox(height: 12),
              year2Dropdown,
            ],
          );
        } else {
          // Use a Row for larger widths
          return Row(
            children: [
              Flexible(child: year1Dropdown),
              const SizedBox(width: 16),
              Flexible(child: year2Dropdown),
            ],
          );
        }
      },
    );
  }
}

/// A widget for selecting the comparison type using choice chips.
class _ComparisonTypeSelector extends ConsumerWidget {
  const _ComparisonTypeSelector({required this.filter});

  final ComparativeFilter filter;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final YearlyComparisonFilterNotifier notifier = ref.read(
      yearlyComparisonFilterProvider.notifier,
    );

    return AppChoiceChips<ComparisonType>(
      selectedValue: filter.type,
      onSelected: notifier.setType,
      options: [
        ChipOption(
          value: ComparisonType.annual,
          label: l10n.comparisonTypeAnnual,
        ),
        ChipOption(
          value: ComparisonType.monthly,
          label: l10n.comparisonTypeMonthly,
        ),
        ChipOption(
          value: ComparisonType.seasonal,
          label: l10n.comparisonTypeSeasonal,
        ),
      ],
    );
  }
}
