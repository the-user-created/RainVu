import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rain_wise/core/application/preferences_provider.dart";
import "package:rain_wise/core/navigation/app_router.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/monthly_breakdown/domain/monthly_breakdown_data.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/user_preferences.dart";
import "package:rain_wise/shared/widgets/buttons/app_icon_button.dart";

class MonthlySummaryCard extends ConsumerWidget {
  const MonthlySummaryCard({
    required this.stats,
    required this.selectedMonth,
    super.key,
  });

  final MonthlySummaryStats stats;
  final DateTime selectedMonth;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final MeasurementUnit unit =
        ref.watch(userPreferencesProvider).value?.measurementUnit ??
        MeasurementUnit.mm;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.yMMMM().format(selectedMonth),
                      style: textTheme.headlineSmall,
                    ),
                    Text(
                      stats.totalRainfall.formatRainfall(context, unit),
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                AppIconButton(
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(24),
                  icon: Icon(
                    Icons.edit,
                    color: colorScheme.secondary,
                    size: 28,
                  ),
                  tooltip: l10n.editEntriesTooltip,
                  onPressed: () {
                    final String monthParam = DateFormat(
                      "yyyy-MM",
                    ).format(selectedMonth);
                    RainfallEntriesRoute(month: monthParam).push(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatItem(
                  value: stats.dailyAverage.formatRainfall(context, unit),
                  label: l10n.dailyAverage,
                ),
                _StatItem(
                  value: stats.highestDay.formatRainfall(context, unit),
                  label: l10n.highestDay,
                ),
                _StatItem(
                  value: stats.lowestDay.formatRainfall(context, unit),
                  label: l10n.lowestDay,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    return Column(
      children: [
        Text(value, style: textTheme.headlineSmall),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
