import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:rain_wise/features/insights/domain/monthly_breakdown_data.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

class DailyBreakdownList extends StatelessWidget {
  const DailyBreakdownList({required this.breakdownItems, super.key});

  final List<DailyBreakdownItem> breakdownItems;

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
            Text("Daily Breakdown", style: theme.titleMedium),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: breakdownItems.length,
              separatorBuilder: (final context, final index) =>
                  const Divider(height: 1),
              itemBuilder: (final context, final index) =>
                  _DailyBreakdownListItem(item: breakdownItems[index]),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyBreakdownListItem extends StatelessWidget {
  const _DailyBreakdownListItem({required this.item});

  final DailyBreakdownItem item;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    final Color varianceColor;
    final IconData varianceIcon;

    if (item.variance > 0) {
      varianceColor = theme.success;
      varianceIcon = Icons.arrow_upward;
    } else if (item.variance < 0) {
      varianceColor = theme.error;
      varianceIcon = Icons.arrow_downward;
    } else {
      varianceColor = theme.secondaryText;
      varianceIcon = Icons.remove;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(DateFormat("MMM d").format(item.date), style: theme.bodyMedium),
          Text(
            "${item.rainfall.toStringAsFixed(1)}mm",
            style: theme.bodyMedium,
          ),
          Row(
            children: [
              Icon(varianceIcon, color: varianceColor, size: 16),
              const SizedBox(width: 4),
              Text(
                "${item.variance.toStringAsFixed(1)}mm",
                style: theme.bodySmall.override(color: varianceColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
