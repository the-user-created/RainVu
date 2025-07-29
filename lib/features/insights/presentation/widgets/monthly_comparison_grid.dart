import "package:flutter/material.dart";
import "package:rain_wise/features/insights/domain/insights_data.dart";
import "package:rain_wise/features/insights/presentation/widgets/mtd_breakdown_card.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

class MonthlyComparisonGrid extends StatelessWidget {
  const MonthlyComparisonGrid({
    required this.comparisons,
    super.key,
  });

  final List<MonthlyComparisonData> comparisons;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Monthly Comparison",
            style: theme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: theme.primaryBackground,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 4,
                  color: Color(0x33000000),
                  offset: Offset(0, 2),
                ),
              ],
              borderRadius: BorderRadius.circular(16),
            ),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                // FIX: Display a single, horizontally scrollable row.
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                mainAxisExtent: screenWidth * 0.45, // Set explicit extent
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
