import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rain_wise/core/navigation/app_router.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/settings/application/preferences_provider.dart";
import "package:rain_wise/features/settings/domain/user_preferences.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/rainfall_entry.dart";

class MonthlySummaryCard extends ConsumerWidget {
  const MonthlySummaryCard({
    required this.currentMonthDate,
    required this.monthlyTotal,
    required this.recentEntries,
    super.key,
  });

  final DateTime currentMonthDate;
  final double monthlyTotal;
  final List<RainfallEntry> recentEntries;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final MeasurementUnit unit =
        ref.watch(userPreferencesProvider).value?.measurementUnit ??
            MeasurementUnit.mm;

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
            _buildTotal(context, theme, l10n, unit),
            const Divider(height: 24, thickness: 1),
            _buildRecentEntriesHeader(theme, l10n),
            const SizedBox(height: 4),
            ...recentEntries.map(
              (final entry) =>
                  _buildRecentEntryRow(context, entry, theme, l10n, unit),
            ),
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
            DateFormat.yMMMM().format(currentMonthDate),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      );

  Widget _buildTotal(
    final BuildContext context,
    final ThemeData theme,
    final AppLocalizations l10n,
    final MeasurementUnit unit,
  ) =>
      Row(
        children: [
          Icon(Icons.water_drop, color: theme.colorScheme.secondary, size: 36),
          const SizedBox(width: 8),
          Text(
            monthlyTotal.formatRainfall(context, unit),
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
    final BuildContext context,
    final RainfallEntry entry,
    final ThemeData theme,
    final AppLocalizations l10n,
    final MeasurementUnit unit,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat.yMd().add_jm().format(entry.date),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              entry.amount.formatRainfall(context, unit),
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
            final String monthParam =
                DateFormat("yyyy-MM").format(currentMonthDate);
            RainfallEntriesRoute(month: monthParam).push(
              context,
            );
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
