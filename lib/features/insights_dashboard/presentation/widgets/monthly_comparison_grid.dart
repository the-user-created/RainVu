import "package:flutter/material.dart";
import "package:rain_wise/features/insights_dashboard/domain/insights_data.dart";
import "package:rain_wise/features/insights_dashboard/presentation/widgets/mtd_breakdown_card.dart";
import "package:rain_wise/l10n/app_localizations.dart";

class MonthlyComparisonGrid extends StatelessWidget {
  const MonthlyComparisonGrid({required this.comparisons, super.key});

  final List<MonthlyComparisonData> comparisons;

  // TODO: Make cards tappable to show more details in a bottom sheet or new screen.
  // TODO: Cards should have a consistent height, and should only grow in width. Currently the monthly breakdown cards grow vertically when the text wraps, causing a jarring format.

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

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
          _buildHorizontalCardList(context, comparisons),
        ],
      ),
    );
  }

  Widget _buildHorizontalCardList(
    final BuildContext context,
    final List<MonthlyComparisonData> comparisons,
  ) {
    if (comparisons.isEmpty) {
      return const SizedBox.shrink();
    }

    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double cardWidth = screenWidth * 0.4;

    final List<Widget> columns = [];
    for (int i = 0; i < comparisons.length; i += 2) {
      columns.add(
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: cardWidth,
                child: MtdBreakdownCard(data: comparisons[i]),
              ),
              if (i + 1 < comparisons.length) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: cardWidth,
                  child: MtdBreakdownCard(data: comparisons[i + 1]),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: columns,
      ),
    );
  }
}
