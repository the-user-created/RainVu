import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:rain_wise/core/navigation/app_router.dart";
import "package:rain_wise/features/insights/domain/monthly_breakdown_data.dart";
import "package:rain_wise/shared/widgets/buttons/app_icon_button.dart";

class MonthlySummaryCard extends StatelessWidget {
  const MonthlySummaryCard({
    required this.stats,
    required this.selectedMonth,
    super.key,
  });

  final MonthlySummaryStats stats;
  final DateTime selectedMonth;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
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
                      "Total Rainfall: ${stats.totalRainfall.toStringAsFixed(1)}mm",
                      style: textTheme.titleMedium
                          ?.copyWith(color: colorScheme.secondary),
                    ),
                  ],
                ),
                AppIconButton(
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(24),
                  icon:
                      Icon(Icons.edit, color: colorScheme.secondary, size: 28),
                  tooltip: "Edit Entries",
                  onPressed: () {
                    final String monthParam =
                        DateFormat("yyyy-MM").format(selectedMonth);
                    RainfallEntriesRoute(month: monthParam).push(
                      context,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatItem(
                  value: "${stats.dailyAverage.toStringAsFixed(1)}mm",
                  label: "Daily Average",
                ),
                _StatItem(
                  value: "${stats.highestDay.toStringAsFixed(1)}mm",
                  label: "Highest Day",
                ),
                _StatItem(
                  value: "${stats.lowestDay.toStringAsFixed(1)}mm",
                  label: "Lowest Day",
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
          style: textTheme.bodySmall
              ?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
