import "package:flutter/material.dart";

class ChartCard extends StatelessWidget {
  const ChartCard({
    required this.title,
    required this.chart,
    this.legend,
    this.chartHeight = 250,
    this.margin = const EdgeInsets.symmetric(horizontal: 16),
    super.key,
  });

  final String title;
  final Widget? legend;
  final Widget chart;
  final double chartHeight;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: margin,
      clipBehavior: Clip.none,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(title, style: theme.textTheme.titleMedium),
                ),
                if (legend != null) legend!,
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(height: chartHeight, child: chart),
          ],
        ),
      ),
    );
  }
}
