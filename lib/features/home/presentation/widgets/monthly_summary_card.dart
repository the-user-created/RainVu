import "package:flutter/material.dart";
import "package:rain_wise/core/navigation/app_router.dart";
import "package:rain_wise/features/home/domain/home_data.dart";
import "package:rain_wise/l10n/app_localizations.dart";

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
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: theme.shadowColor,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, theme, l10n),
            const SizedBox(height: 8),
            _buildTotal(theme),
            const Divider(height: 24, thickness: 1),
            _buildRecentEntriesHeader(theme, l10n),
            const SizedBox(height: 4),
            ...recentEntries
                .map((final entry) => _buildRecentEntryRow(entry, theme)),
            const SizedBox(height: 8),
            _buildViewHistoryButton(context, theme, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    final BuildContext context,
    final ThemeData theme,
    final AppLocalizations l10n,
  ) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.monthlyRainfallTitle,
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

  Widget _buildRecentEntriesHeader(
    final ThemeData theme,
    final AppLocalizations l10n,
  ) =>
      Text(
        l10n.recentEntriesTitle,
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
    final AppLocalizations l10n,
  ) =>
      Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () {
            // TODO: Take user to monthly breakdown for the *current* month
            const MonthlyBreakdownRoute().push(context);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.viewFullHistoryLink,
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
