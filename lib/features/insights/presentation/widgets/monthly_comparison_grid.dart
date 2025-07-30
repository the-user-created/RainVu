import "package:flutter/material.dart";
import "package:rain_wise/features/insights/domain/insights_data.dart";
import "package:rain_wise/features/insights/presentation/widgets/mtd_breakdown_card.dart";

class MonthlyComparisonGrid extends StatelessWidget {
  const MonthlyComparisonGrid({
    required this.comparisons,
    super.key,
  });

  final List<MonthlyComparisonData> comparisons;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Monthly Comparison",
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 180,
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                mainAxisExtent: screenWidth * 0.45,
              ),
              itemCount: comparisons.length,
              itemBuilder: (final context, final index) =>
                  MtdBreakdownCard(data: comparisons[index]),
            ),
          ),
        ],
      ),
    );
  }
}
