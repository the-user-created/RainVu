import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:rain_wise/core/navigation/app_router.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/insights_dashboard/domain/insights_data.dart";
import "package:rain_wise/features/insights_dashboard/presentation/widgets/monthly_comparison_card.dart";
import "package:rain_wise/l10n/app_localizations.dart";

class MonthlyComparisonGrid extends StatelessWidget {
  const MonthlyComparisonGrid({required this.comparisons, super.key});

  final List<MonthlyComparisonData> comparisons;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    if (comparisons.isEmpty) {
      return const SizedBox.shrink();
    }

    final int currentYear = DateTime.now().year;

    // Create a map for efficient month name to number conversion.
    final Map<String, int> monthNameToNumber = {
      for (int i = 1; i <= 12; i++) DateFormat.MMMM().format(DateTime(0, i)): i,
    };

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
                .map((final data) {
                  final int? monthNumber = monthNameToNumber[data.month];
                  return MonthlyComparisonCard(
                    data: data,
                    onTap: monthNumber == null
                        ? null
                        : () {
                            // Format as YYYY-MM for the route parameter.
                            final String monthParam =
                                "$currentYear-${monthNumber.toString().padLeft(2, '0')}";
                            MonthlyBreakdownRoute(
                              month: monthParam,
                            ).push(context);
                          },
                  );
                })
                .toList()
                .divide(const SizedBox(width: 12)),
          ),
        ),
      ],
    );
  }
}
