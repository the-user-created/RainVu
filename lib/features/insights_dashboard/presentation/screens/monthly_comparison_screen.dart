import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rain_wise/core/navigation/app_router.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/insights_dashboard/application/insights_providers.dart";
import "package:rain_wise/features/insights_dashboard/domain/insights_data.dart";
import "package:rain_wise/features/insights_dashboard/presentation/widgets/monthly_comparison_card.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";

class MonthlyComparisonScreen extends ConsumerWidget {
  const MonthlyComparisonScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<InsightsData> insightsDataAsync = ref.watch(
      insightsScreenDataProvider,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.monthlyComparisonTitle)),
      body: SafeArea(
        child: insightsDataAsync.when(
          loading: () => const AppLoader(),
          error: (final err, final stack) =>
              Center(child: Text(l10n.insightsError(err))),
          data: (final data) {
            if (data.monthlyComparisons.isEmpty) {
              return _EmptyState(
                icon: Icons.bar_chart_outlined,
                title: l10n.monthlyComparisonEmptyTitle,
                message: l10n.monthlyComparisonEmptyMessage,
              );
            }
            return ListView(
              padding: const EdgeInsets.all(16),
              children: _buildComparisonCards(context, data.monthlyComparisons),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildComparisonCards(
    final BuildContext context,
    final List<MonthlyComparisonData> comparisons,
  ) {
    final int currentYear = DateTime.now().year;

    // Create a map for efficient month name to number conversion.
    final Map<String, int> monthNameToNumber = {
      for (int i = 1; i <= 12; i++) DateFormat.MMMM().format(DateTime(0, i)): i,
    };

    return comparisons
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
                    MonthlyBreakdownRoute(month: monthParam).push(context);
                  },
          );
        })
        .toList()
        .divide(const SizedBox(height: 12));
  }
}

/// A private, self-contained widget to display an "empty state" message.
class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: colorScheme.secondary.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
