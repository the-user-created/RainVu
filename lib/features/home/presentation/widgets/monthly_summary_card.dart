import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:rain_wise/core/navigation/app_route_names.dart";

class RecentEntry {
  const RecentEntry({required this.dateLabel, required this.amount});

  final String dateLabel;
  final String amount;
}

class MonthlySummaryCard extends StatelessWidget {
  const MonthlySummaryCard({
    required this.currentMonth,
    required this.monthlyTotal,
    required this.recentEntries,
    super.key,
  });

  final String currentMonth;
  final String monthlyTotal;
  final List<RecentEntry> recentEntries;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            color: Color(0x33000000),
            offset: Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, theme),
            const SizedBox(height: 8),
            _buildTotal(theme),
            const Divider(height: 24, thickness: 1),
            _buildRecentEntriesHeader(theme),
            const SizedBox(height: 4),
            ...recentEntries
                .map((final entry) => _buildRecentEntryRow(entry, theme)),
            const SizedBox(height: 8),
            _buildViewHistoryButton(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    final BuildContext context,
    final ThemeData theme,
  ) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Monthly Rainfall",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            currentMonth,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      );

  Widget _buildTotal(final ThemeData theme) => Row(
        children: [
          Icon(Icons.water_drop, color: theme.colorScheme.secondary, size: 36),
          const SizedBox(width: 8),
          Text(
            monthlyTotal,
            style: theme.textTheme.displaySmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );

  Widget _buildRecentEntriesHeader(final ThemeData theme) => Text(
        "Recent Entries",
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      );

  Widget _buildRecentEntryRow(
    final RecentEntry entry,
    final ThemeData theme,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              entry.dateLabel,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              entry.amount,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );

  Widget _buildViewHistoryButton(
    final BuildContext context,
    final ThemeData theme,
  ) =>
      Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () {
            // TODO: Take user to monthly breakdown for the *current* month
            context.pushNamed(AppRouteNames.monthlyBreakdownName);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "View Full History",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_rounded,
                color: theme.colorScheme.secondary,
                size: 20,
              ),
            ],
          ),
        ),
      );
}
