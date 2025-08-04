import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/insights/application/seasonal_patterns_provider.dart";
import "package:rain_wise/features/insights/domain/seasonal_patterns_data.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/widgets/forms/app_dropdown.dart";

class SeasonSelector extends ConsumerWidget {
  const SeasonSelector({super.key});

  String _getSeasonName(final AppLocalizations l10n, final Season season) {
    switch (season) {
      case Season.spring:
        return l10n.seasonSpring;
      case Season.summer:
        return l10n.seasonSummer;
      case Season.autumn:
        return l10n.seasonAutumn;
      case Season.winter:
        return l10n.seasonWinter;
    }
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final AppLocalizations l10n = AppLocalizations.of(context);
    final SeasonalFilter filter =
        ref.watch(seasonalPatternsFilterNotifierProvider);
    final SeasonalPatternsFilterNotifier notifier =
        ref.read(seasonalPatternsFilterNotifierProvider.notifier);
    final int currentYear = DateTime.now().year;

    // Generate a list of years, e.g., from 10 years ago to the current year
    final List<int> years =
        List.generate(11, (final index) => currentYear - index);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: AppDropdown<Season>(
              value: filter.season,
              items: Season.values
                  .map(
                    (final season) => DropdownMenuItem<Season>(
                      value: season,
                      child: Text(_getSeasonName(l10n, season)),
                    ),
                  )
                  .toList(),
              onChanged: (final season) {
                if (season != null) {
                  notifier.setFilter(season, filter.year);
                }
              },
              fillColor: colorScheme.surfaceContainerHighest,
              borderColor: Colors.transparent,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AppDropdown<int>(
              value: filter.year,
              items: years
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
              fillColor: colorScheme.surfaceContainerHighest,
              borderColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
