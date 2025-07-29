import "package:flutter/material.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

class DataExplanationCard extends StatelessWidget {
  const DataExplanationCard({super.key});

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
            Text("Understanding the Data", style: theme.titleMedium),
            const SizedBox(height: 16),
            Text(
              "This analysis combines historical rainfall data from your registered rain gauges to identify seasonal patterns. The trends shown represent average daily rainfall amounts during the selected season, helping you identify typical patterns and anomalies. Use this information to plan irrigation schedules and crop timing.",
              style: theme.bodyMedium.override(color: theme.secondaryText),
            ),
          ],
        ),
      ),
    );
  }
}
