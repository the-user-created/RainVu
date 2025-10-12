import "package:flutter/material.dart";

class ChartCard extends StatelessWidget {
  const ChartCard({
    required this.title,
    required this.chart,
    this.legend,
    this.margin = const EdgeInsets.symmetric(horizontal: 16),
    super.key,
  });

  final String title;
  final Widget? legend;
  final Widget chart;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: margin,
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 8,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                if (legend != null) legend!,
              ],
            ),
            const SizedBox(height: 16),
            chart,
          ],
        ),
      ),
    );
  }
}
