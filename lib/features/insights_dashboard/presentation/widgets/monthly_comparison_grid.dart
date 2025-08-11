import "package:flutter/material.dart";
import "package:rain_wise/features/insights_dashboard/domain/insights_data.dart";
import "package:rain_wise/features/insights_dashboard/presentation/widgets/mtd_breakdown_card.dart";
import "package:rain_wise/l10n/app_localizations.dart";

class MonthlyComparisonGrid extends StatelessWidget {
  const MonthlyComparisonGrid({
    required this.comparisons,
    super.key,
  });

  final List<MonthlyComparisonData> comparisons;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.monthlyComparisonTitle,
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
