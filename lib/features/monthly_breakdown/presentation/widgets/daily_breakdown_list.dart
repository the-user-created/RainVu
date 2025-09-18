import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rain_wise/core/ui/custom_colors.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/monthly_breakdown/domain/monthly_breakdown_data.dart";
import "package:rain_wise/features/settings/application/preferences_provider.dart";
import "package:rain_wise/features/settings/domain/user_preferences.dart";
import "package:rain_wise/l10n/app_localizations.dart";

class DailyBreakdownList extends ConsumerWidget {
  const DailyBreakdownList({required this.breakdownItems, super.key});

  final List<DailyBreakdownItem> breakdownItems;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final AppLocalizations l10n = AppLocalizations.of(context);
    final MeasurementUnit unit =
        ref.watch(userPreferencesProvider).value?.measurementUnit ??
            MeasurementUnit.mm;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.dailyBreakdownTitle, style: textTheme.titleMedium),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: breakdownItems.length,
              separatorBuilder: (final context, final index) =>
                  const Divider(height: 1),
              itemBuilder: (final context, final index) =>
                  _DailyBreakdownListItem(
                item: breakdownItems[index],
                unit: unit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyBreakdownListItem extends StatelessWidget {
  const _DailyBreakdownListItem({required this.item, required this.unit});

  final DailyBreakdownItem item;
  final MeasurementUnit unit;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final Color varianceColor;
    final IconData varianceIcon;

    if (item.variance > 0) {
      varianceColor = colorScheme.success;
      varianceIcon = Icons.arrow_upward;
    } else if (item.variance < 0) {
      varianceColor = colorScheme.error;
      varianceIcon = Icons.arrow_downward;
    } else {
      varianceColor = colorScheme.onSurfaceVariant;
      varianceIcon = Icons.remove;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat("MMM d").format(item.date),
            style: textTheme.bodyMedium,
          ),
          Text(
            item.rainfall.formatRainfall(context, unit),
            style: textTheme.bodyMedium,
          ),
          Row(
            children: [
              Icon(varianceIcon, color: varianceColor, size: 16),
              const SizedBox(width: 4),
              Text(
                item.variance.formatRainfall(context, unit),
                style: textTheme.bodySmall?.copyWith(color: varianceColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
