import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/insights/application/seasonal_patterns_provider.dart";
import "package:rain_wise/features/insights/domain/seasonal_patterns_data.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

class SeasonSelector extends ConsumerWidget {
  const SeasonSelector({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    final SeasonalFilter filter = ref.watch(seasonalPatternsFilterNotifierProvider);
    final SeasonalPatternsFilterNotifier notifier = ref.read(seasonalPatternsFilterNotifierProvider.notifier);
    final int currentYear = DateTime.now().year;

    // Generate a list of years, e.g., from 10 years ago to the current year
    final List<int> years = List.generate(11, (final index) => currentYear - index);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.alternate,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDropdown<Season>(
            context: context,
            value: filter.season,
            items: Season.values,
            onChanged: (final season) {
              if (season != null) {
                notifier.setFilter(season, filter.year);
              }
            },
            itemBuilder: (final season) => Text(season.name),
          ),
          _buildDropdown<int>(
            context: context,
            value: filter.year,
            items: years,
            onChanged: (final year) {
              if (year != null) {
                notifier.setFilter(filter.season, year);
              }
            },
            itemBuilder: (final year) => Text(year.toString()),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required final BuildContext context,
    required final T value,
    required final List<T> items,
    required final void Function(T?) onChanged,
    required final Widget Function(T) itemBuilder,
  }) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    return DropdownButton<T>(
      value: value,
      items: items
          .map(
            (final item) => DropdownMenuItem<T>(
              value: item,
              child: itemBuilder(item),
            ),
          )
          .toList(),
      onChanged: onChanged,
      underline: const SizedBox.shrink(),
      style: theme.bodyMedium,
      dropdownColor: theme.secondaryBackground,
      icon: Icon(Icons.expand_more, color: theme.primary),
    );
  }
}
