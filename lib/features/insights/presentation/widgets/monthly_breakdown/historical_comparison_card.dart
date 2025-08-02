import "package:flutter/material.dart";
import "package:rain_wise/core/ui/custom_colors.dart";
import "package:rain_wise/features/insights/domain/monthly_breakdown_data.dart";

class HistoricalComparisonCard extends StatelessWidget {
  const HistoricalComparisonCard({
    required this.stats,
    required this.currentTotal,
    super.key,
  });

  final HistoricalComparisonStats stats;
  final double currentTotal;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Historical Comparison", style: textTheme.titleMedium),
            const SizedBox(height: 16),
            _ComparisonRow(
              label: "2 Year Average",
              avgValue: stats.twoYearAvg,
              currentValue: currentTotal,
            ),
            const SizedBox(height: 12),
            _ComparisonRow(
              label: "5 Year Average",
              avgValue: stats.fiveYearAvg,
              currentValue: currentTotal,
            ),
            const SizedBox(height: 12),
            _ComparisonRow(
              label: "10 Year Average",
              avgValue: stats.tenYearAvg,
              currentValue: currentTotal,
            ),
          ],
        ),
      ),
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  const _ComparisonRow({
    required this.label,
    required this.avgValue,
    required this.currentValue,
  });

  final String label;
  final double avgValue;
  final double currentValue;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final double diff = currentValue - avgValue;
    final num percentage = avgValue == 0 ? 0 : (diff / avgValue) * 100;
    final Color color = diff >= 0 ? colorScheme.success : colorScheme.error;
    final IconData icon = diff >= 0 ? Icons.arrow_upward : Icons.arrow_downward;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: textTheme.bodyMedium),
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${diff >= 0 ? '+' : ''}${percentage.toStringAsFixed(0)}%',
                  style: textTheme.bodyMedium?.copyWith(color: color),
                ),
              ],
            ),
          ],
        ),
        Text("${avgValue.toStringAsFixed(1)}mm", style: textTheme.bodyMedium),
      ],
    );
  }
}
