import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/insights/application/comparative_analysis_provider.dart";
import "package:rain_wise/features/insights/domain/comparative_analysis_data.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";
import "package:rain_wise/shared/widgets/forms/app_dropdown.dart";
import "package:rain_wise/shared/widgets/forms/app_segmented_control.dart";

class ComparativeAnalysisFilters extends ConsumerWidget {
  const ComparativeAnalysisFilters({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final AsyncValue<ComparativeFilter> filterAsync =
        ref.watch(comparativeAnalysisFilterNotifierProvider);
    final AsyncValue<List<int>> availableYearsAsync =
        ref.watch(availableYearsProvider);

    return Card(
      elevation: 2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Container(
        color: colorScheme.surface,
        padding: const EdgeInsets.all(16),
        child: filterAsync.when(
          loading: () => const SizedBox(height: 150, child: AppLoader()),
          error: (final e, final s) => Center(child: Text("Error: $e")),
          data: (final filter) => availableYearsAsync.when(
            loading: () => const SizedBox(height: 150, child: AppLoader()),
            error: (final e, final s) =>
                Center(child: Text("Error loading years: $e")),
            data: (final availableYears) => Column(
              children: [
                Text("Select Years to Compare", style: textTheme.titleMedium),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: AppDropdown<int>(
                        value: filter.year1,
                        items: availableYears
                            .map(
                              (final year) => DropdownMenuItem<int>(
                                value: year,
                                enabled: year != filter.year2,
                                child: Text(
                                  year.toString(),
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: year != filter.year2
                                        ? colorScheme.onSurface
                                        : colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (final year) {
                          if (year != null) {
                            ref
                                .read(
                                  comparativeAnalysisFilterNotifierProvider
                                      .notifier,
                                )
                                .setYear1(year);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AppDropdown<int>(
                        value: filter.year2,
                        items: availableYears
                            .map(
                              (final year) => DropdownMenuItem<int>(
                                value: year,
                                enabled: year != filter.year1,
                                child: Text(
                                  year.toString(),
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: year != filter.year1
                                        ? colorScheme.onSurface
                                        : colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (final year) {
                          if (year != null) {
                            ref
                                .read(
                                  comparativeAnalysisFilterNotifierProvider
                                      .notifier,
                                )
                                .setYear2(year);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AppSegmentedControl<ComparisonType>(
                  selectedValue: filter.type,
                  onSelectionChanged: (final selection) {
                    ref
                        .read(
                          comparativeAnalysisFilterNotifierProvider.notifier,
                        )
                        .setType(selection);
                  },
                  segments: const [
                    SegmentOption(
                      value: ComparisonType.annual,
                      label: Text("Annual"),
                    ),
                    SegmentOption(
                      value: ComparisonType.monthly,
                      label: Text("Monthly"),
                      enabled: false,
                    ), // TODO: Disabled for now
                    SegmentOption(
                      value: ComparisonType.seasonal,
                      label: Text("Seasonal"),
                      enabled: false,
                    ), // TODO: Disabled for now
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
