import "package:flutter/material.dart";

class DataExplanationCard extends StatelessWidget {
  const DataExplanationCard({super.key});

  @override
  Widget build(final BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Understanding the Data", style: textTheme.titleMedium),
            const SizedBox(height: 16),
            Text(
              "This analysis combines historical rainfall data from your registered rain gauges to identify seasonal patterns. The trends shown represent average daily rainfall amounts during the selected season, helping you identify typical patterns and anomalies. Use this information to plan irrigation schedules and crop timing.",
              style: textTheme.bodyMedium
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
