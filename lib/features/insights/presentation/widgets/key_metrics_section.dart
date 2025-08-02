import "package:flutter/material.dart";
import "package:rain_wise/features/insights/domain/insights_data.dart";

class KeyMetricsSection extends StatelessWidget {
  const KeyMetricsSection({
    required this.metrics,
    super.key,
  });

  final KeyMetrics metrics;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final Color successColor = colorScheme.tertiary;
    final Color errorColor = colorScheme.error;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            color: Color(0x33000000),
            offset: Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              "Key Metrics",
              style: textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _MetricCard(
                  title: "Total Rainfall",
                  value: "${metrics.totalRainfall} mm",
                  changeText:
                      "${metrics.totalRainfallPrevYearChange}% vs last year",
                  changeColor: metrics.totalRainfallPrevYearChange >= 0
                      ? successColor
                      : errorColor,
                ),
                _MetricCard(
                  title: "MTD Total",
                  value: "${metrics.mtdTotal} mm",
                  changeText:
                      "${metrics.mtdTotalPrevMonthChange}% vs last month",
                  changeColor: metrics.mtdTotalPrevMonthChange >= 0
                      ? successColor
                      : errorColor,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _MetricCard(
                  title: "YTD Total",
                  value: "${metrics.ytdTotal} mm",
                  changeText: "On track for yearly goal",
                  changeColor: successColor,
                ),
                _MetricCard(
                  title: "Monthly Avg",
                  value: "${metrics.monthlyAvg} mm",
                  changeText: "Based on 12 month data",
                  changeColor: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.changeText,
    required this.changeColor,
  });

  final String title;
  final String value;
  final String changeText;
  final Color changeColor;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final double cardWidth = MediaQuery.sizeOf(context).width * 0.42;

    return Card(
      elevation: 2,
      color: colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: cardWidth,
        height: 130,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: textTheme.bodyMedium),
                Icon(
                  Icons.info_outline,
                  color: colorScheme.secondary,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.headlineMedium?.copyWith(
                fontSize: 26,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              changeText,
              style: textTheme.bodySmall?.copyWith(
                color: changeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
