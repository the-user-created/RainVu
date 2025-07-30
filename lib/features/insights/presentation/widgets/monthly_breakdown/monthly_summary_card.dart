import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:intl/intl.dart";
import "package:rain_wise/core/navigation/app_route_names.dart";
import "package:rain_wise/features/insights/domain/monthly_breakdown_data.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
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
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                      style: theme.headlineSmall,
                    ),
                    Text(
                      "Total Rainfall: ${stats.totalRainfall.toStringAsFixed(1)}mm",
                      style: theme.titleMedium.override(color: theme.primary),
                    ),
                  ],
                ),
                AppIconButton(
                  backgroundColor: theme.alternate,
                  borderRadius: BorderRadius.circular(24),
                  icon: Icon(Icons.edit, color: theme.primary, size: 28),
                  tooltip: "Edit Entries",
                  onPressed: () {
                    final String monthParam =
                        DateFormat("yyyy-MM").format(selectedMonth);
                    context.pushNamed(
                      AppRouteNames.rainfallEntriesName,
                      pathParameters: {"month": monthParam},
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
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    return Column(
      children: [
        Text(value, style: theme.headlineSmall),
        Text(
          label,
          style: theme.bodySmall.override(color: theme.secondaryText),
        ),
      ],
    );
  }
}
