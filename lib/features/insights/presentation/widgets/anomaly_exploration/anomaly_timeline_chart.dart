import "package:flutter/material.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

class AnomalyTimelineChart extends StatelessWidget {
  const AnomalyTimelineChart({super.key});

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Rainfall Trends", style: theme.titleMedium),
                Row(
                  children: [
                    _LegendItem(
                      color: theme.primary.withValues(alpha: 0.5),
                      text: "Normal",
                    ),
                    const SizedBox(width: 8),
                    _LegendItem(color: theme.error, text: "Anomaly"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 240,
              // TODO: Replace with real data from a provider
              // For now, this is a placeholder chart.
              child: Text(
                "Interactive Chart Coming Soon",
                style: theme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.text,
  });

  final Color color;
  final String text;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(text, style: theme.bodySmall),
      ],
    );
  }
}
