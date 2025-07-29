import "package:flutter/material.dart";
import "package:rain_wise/features/insights/domain/seasonal_patterns_data.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

class SeasonalSummaryCard extends StatelessWidget {
  const SeasonalSummaryCard({required this.summary, super.key});

  final SeasonalSummary summary;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Season Summary", style: theme.titleMedium),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MetricItem(
                  label: "Average Rainfall",
                  value: "${summary.averageRainfall.toStringAsFixed(1)} mm",
                  valueStyle: theme.headlineSmall,
                ),
                _VerticalDivider(),
                _TrendMetricItem(
                  label: "Trend vs History",
                  percentage: summary.trendVsHistory,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MetricItem(
                  label: "Highest Recorded",
                  value: "${summary.highestRecorded.toStringAsFixed(1)} mm",
                ),
                _VerticalDivider(),
                _MetricItem(
                  label: "Lowest Recorded",
                  value: "${summary.lowestRecorded.toStringAsFixed(1)} mm",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({
    required this.label,
    required this.value,
    this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle? valueStyle;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.bodyMedium.override(color: theme.secondaryText),
        ),
        Text(value, style: valueStyle ?? theme.bodyLarge),
      ],
    );
  }
}

class _TrendMetricItem extends StatelessWidget {
  const _TrendMetricItem({required this.label, required this.percentage});

  final String label;
  final double percentage;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    final bool isPositive = percentage >= 0;
    final Color color = isPositive ? theme.success : theme.error;
    final IconData icon = isPositive ? Icons.trending_up : Icons.trending_down;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.bodyMedium.override(color: theme.secondaryText),
        ),
        Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 8),
            Text(
              "${isPositive ? '+' : ''}${percentage.toStringAsFixed(0)}%",
              style: theme.headlineSmall.override(color: color),
            ),
          ],
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(final BuildContext context) => Container(
        width: 1,
        height: 40,
        color: FlutterFlowTheme.of(context).alternate,
      );
}
