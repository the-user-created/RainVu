import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/seasonal_patterns/application/seasonal_patterns_provider.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/seasons.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";
import "package:rain_wise/shared/widgets/forms/app_dropdown.dart";

class SeasonSelector extends ConsumerWidget {
  const SeasonSelector({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final SeasonalFilter filter = ref.watch(seasonalPatternsFilterProvider);
    final SeasonalPatternsFilterNotifier notifier = ref.read(
      seasonalPatternsFilterProvider.notifier,
    );
    final AsyncValue<List<int>> availableYearsAsync = ref.watch(
      availableYearsProvider,
    );

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: AppDropdown<Season>(
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
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: availableYearsAsync.when(
            data: (final years) {
              final List<int> displayYears = years.isNotEmpty
                  ? years
                  : [DateTime.now().year]; // Fallback for no data
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
            loading: () => const Center(child: AppLoader()),
            error: (final e, final s) => const Center(child: Icon(Icons.error)),
          ),
        ),
      ],
    );
  }
}
