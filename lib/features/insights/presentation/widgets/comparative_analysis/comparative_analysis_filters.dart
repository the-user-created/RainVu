import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/insights/application/comparative_analysis_provider.dart";
import "package:rain_wise/features/insights/domain/comparative_analysis_data.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";

class ComparativeAnalysisFilters extends ConsumerWidget {
  const ComparativeAnalysisFilters({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
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
        color: theme.primaryBackground,
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
                Text("Select Years to Compare", style: theme.titleMedium),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _YearSelector(
                      availableYears: availableYears,
                      selectedYear: filter.year1,
                      otherSelectedYear: filter.year2,
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
                    _YearSelector(
                      availableYears: availableYears,
                      selectedYear: filter.year2,
                      otherSelectedYear: filter.year1,
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
                  ],
                ),
                const SizedBox(height: 16),
                SegmentedButton<ComparisonType>(
                  segments: const [
                    ButtonSegment(
                      value: ComparisonType.annual,
                      label: Text("Annual"),
                    ),
                    ButtonSegment(
                      value: ComparisonType.monthly,
                      label: Text("Monthly"),
                      enabled: false,
                    ), // TODO: Disabled for now
                    ButtonSegment(
                      value: ComparisonType.seasonal,
                      label: Text("Seasonal"),
                      enabled: false,
                    ), // TODO: Disabled for now
                  ],
                  selected: {filter.type},
                  onSelectionChanged: (final selection) {
                    ref
                        .read(
                          comparativeAnalysisFilterNotifierProvider.notifier,
                        )
                        .setType(selection.first);
                  },
                  style: SegmentedButton.styleFrom(
                    backgroundColor: theme.alternate,
                    foregroundColor: theme.secondaryText,
                    selectedBackgroundColor: theme.primary,
                    selectedForegroundColor: theme.primaryBackground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _YearSelector extends StatelessWidget {
  const _YearSelector({
    required this.availableYears,
    required this.selectedYear,
    required this.otherSelectedYear,
    required this.onChanged,
  });

  final List<int> availableYears;
  final int selectedYear;
  final int otherSelectedYear;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.4,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: theme.alternate,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedYear,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: theme.primary),
          items: availableYears
              .map(
                (final year) => DropdownMenuItem<int>(
                  value: year,
                  // Disable selection if it's the same as the other year
                  enabled: year != otherSelectedYear,
                  child: Text(
                    year.toString(),
                    style: theme.bodyMedium.override(
                      color: year != otherSelectedYear
                          ? theme.primaryText
                          : theme.secondaryText,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
