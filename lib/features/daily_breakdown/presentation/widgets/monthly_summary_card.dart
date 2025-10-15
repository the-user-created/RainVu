import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rainvu/core/application/preferences_provider.dart";
import "package:rainvu/core/navigation/app_router.dart";
import "package:rainvu/core/utils/extensions.dart";
import "package:rainvu/features/daily_breakdown/domain/daily_breakdown_data.dart";
import "package:rainvu/l10n/app_localizations.dart";
import "package:rainvu/shared/domain/user_preferences.dart";
import "package:rainvu/shared/widgets/buttons/app_button.dart";

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat.yMMMM().format(selectedMonth),
                        style: textTheme.headlineSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stats.totalRainfall.formatRainfall(context, unit),
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.spaceAround,
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
            const SizedBox(height: 20),
            AppButton(
              label: l10n.viewEntriesButtonLabel,
              onPressed: () {
                final String monthParam = DateFormat(
                  "yyyy-MM",
                ).format(selectedMonth);
                RainfallEntriesRoute(month: monthParam).push(context);
              },
              style: AppButtonStyle.secondary,
              size: AppButtonSize.small,
              isExpanded: true,
              icon: const Icon(Icons.list_alt_rounded, size: 18),
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
        Text(value, style: textTheme.titleLarge),
        const SizedBox(height: 4),
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
