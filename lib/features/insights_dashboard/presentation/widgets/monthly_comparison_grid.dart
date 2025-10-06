import "package:flutter/material.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/insights_dashboard/domain/insights_data.dart";
import "package:rain_wise/features/insights_dashboard/presentation/widgets/monthly_comparison_card.dart";
import "package:rain_wise/l10n/app_localizations.dart";

class MonthlyComparisonGrid extends StatelessWidget {
  const MonthlyComparisonGrid({required this.comparisons, super.key});

  final List<MonthlyComparisonData> comparisons;

  // TODO: Make cards tappable to show more details in a bottom sheet or new screen.

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    if (comparisons.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            l10n.monthlyComparisonTitle,
            style: theme.textTheme.headlineSmall,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
          clipBehavior: Clip.none,
          child: Row(
            children: comparisons
                .map((final data) => MonthlyComparisonCard(data: data))
                .toList()
                .divide(const SizedBox(width: 12)),
          ),
        ),
      ],
    );
  }
}
