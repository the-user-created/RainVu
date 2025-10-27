import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rainvu/core/navigation/app_router.dart";
import "package:rainvu/core/utils/extensions.dart";
import "package:rainvu/features/insights_dashboard/application/insights_providers.dart";
import "package:rainvu/features/insights_dashboard/domain/insights_data.dart";
import "package:rainvu/features/insights_dashboard/presentation/widgets/monthly_averages_card.dart";
import "package:rainvu/l10n/app_localizations.dart";
import "package:rainvu/shared/widgets/buttons/app_icon_button.dart";
import "package:rainvu/shared/widgets/placeholders.dart";
import "package:rainvu/shared/widgets/sheets/info_sheet.dart";
import "package:shimmer/shimmer.dart";

class MonthlyAveragesScreen extends ConsumerWidget {
  const MonthlyAveragesScreen({super.key});

  void _showInfoSheet(final BuildContext context, final AppLocalizations l10n) {
    InfoSheet.show(
      context,
      title: l10n.monthlyAveragesInfoSheetTitle,
      items: [
        InfoSheetItem(
          icon: Icons.compare_arrows_outlined,
          title: "", // Title is already in the sheet's main title
          description: l10n.monthlyAveragesInfoDescription,
        ),
      ],
    );
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<InsightsData> insightsDataAsync = ref.watch(
      dashboardDataProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.monthlyComparisonTitle, style: theme.textTheme.titleLarge),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: AppIconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => _showInfoSheet(context, l10n),
              tooltip: l10n.infoTooltip,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: insightsDataAsync.when(
          loading: () => const _LoadingState(),
          error: (final err, final stack) =>
              Center(child: Text(l10n.insightsError)),
          data: (final data) {
            if (data.monthlyAverages.isEmpty) {
              return _EmptyState(
                icon: Icons.bar_chart_outlined,
                title: l10n.monthlyComparisonEmptyTitle,
                message: l10n.monthlyComparisonEmptyMessage,
              );
            }
            return ListView(
              padding: const EdgeInsets.all(16),
              children: _buildComparisonCards(context, data.monthlyAverages),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildComparisonCards(
    final BuildContext context,
    final List<MonthlyAveragesData> comparisons,
  ) {
    final int currentYear = DateTime.now().year;

    // Create a map for efficient month name to number conversion.
    final Map<String, int> monthNameToNumber = {
      for (int i = 1; i <= 12; i++) DateFormat.MMMM().format(DateTime(0, i)): i,
    };

    return comparisons
        .map((final data) {
          final int? monthNumber = monthNameToNumber[data.month];
          return MonthlyAveragesCard(
            data: data,
            onTap: monthNumber == null
                ? null
                : () {
                    // Format as YYYY-MM for the route parameter.
                    final String monthParam =
                        "$currentYear-${monthNumber.toString().padLeft(2, '0')}";
                    DailyBreakdownRoute(month: monthParam).push(context);
                  },
          );
        })
        .toList()
        .divide(const SizedBox(height: 12));
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Shimmer.fromColors(
      baseColor: theme.colorScheme.surfaceContainerHighest,
      highlightColor: theme.colorScheme.surface,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        separatorBuilder: (final context, final index) =>
            const SizedBox(height: 12),
        itemBuilder: (final context, final index) =>
            const CardPlaceholder(height: 200),
      ),
    );
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
