import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rainvu/features/seasonal_trends/application/seasonal_trends_provider.dart";
import "package:rainvu/l10n/app_localizations.dart";
import "package:rainvu/shared/domain/seasons.dart";
import "package:rainvu/shared/widgets/forms/app_dropdown.dart";
import "package:rainvu/shared/widgets/placeholders.dart";
import "package:shimmer/shimmer.dart";

class SeasonSelector extends ConsumerWidget {
  const SeasonSelector({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final SeasonalFilter filter = ref.watch(seasonalTrendsFilterProvider);
    final SeasonalTrendsFilterNotifier notifier = ref.read(
      seasonalTrendsFilterProvider.notifier,
    );
    final AsyncValue<List<int>> availableYearsAsync = ref.watch(
      availableYearsProvider,
    );
    final ThemeData theme = Theme.of(context);

    final Widget seasonDropdown = AppDropdown<Season>(
      value: filter.season,
      items: Season.values
          .map(
            (final season) => DropdownMenuItem<Season>(
              value: season,
              child: Text(season.getName(l10n)),
            ),
          )
          .toList(),
      onChanged: (final season) {
        if (season != null) {
          notifier.setFilter(season, filter.year);
        }
      },
    );

    final Widget yearDropdown = availableYearsAsync.when(
      data: (final years) {
        final List<int> displayYears = years.isNotEmpty
            ? years
            : [DateTime.now().year];
        return AppDropdown<int>(
          value: filter.year,
          items: displayYears
              .map(
                (final year) => DropdownMenuItem<int>(
                  value: year,
                  child: Text(year.toString()),
                ),
              )
              .toList(),
          onChanged: (final year) {
            if (year != null) {
              notifier.setFilter(filter.season, year);
            }
          },
        );
      },
      loading: () => Shimmer.fromColors(
        baseColor: theme.colorScheme.surfaceContainerHighest,
        highlightColor: theme.colorScheme.surface,
        child: const DropdownPlaceholder(),
      ),
      error: (final e, final s) => const Center(child: Icon(Icons.error)),
    );

    return LayoutBuilder(
      builder: (final context, final constraints) {
        const double breakpoint = 350;
        final bool useRow = constraints.maxWidth > breakpoint;

        if (useRow) {
          return Row(
            children: [
              Expanded(flex: 3, child: seasonDropdown),
              const SizedBox(width: 16),
              Expanded(flex: 2, child: yearDropdown),
            ],
          );
        } else {
          return Column(
            // Ensure dropdowns stretch to fill the width of the column.
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              seasonDropdown,
              const SizedBox(height: 12),
              yearDropdown,
            ],
          );
        }
      },
    );
  }
}
