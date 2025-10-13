import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/application/preferences_provider.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/seasonal_trends/domain/seasonal_trends_data.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/user_preferences.dart";
import "package:rain_wise/shared/widgets/buttons/app_icon_button.dart";
import "package:rain_wise/shared/widgets/sheets/info_sheet.dart";

class SeasonalSummaryCard extends ConsumerWidget {
  const SeasonalSummaryCard({required this.summary, super.key});

  final SeasonalSummary summary;

  void _showInfoSheet(final BuildContext context, final AppLocalizations l10n) {
    InfoSheet.show(
      context,
      title: l10n.seasonSummaryInfoSheetTitle,
      items: [
        InfoSheetItem(
          icon: Icons.water_drop_outlined,
          title: l10n.seasonSummaryAverageRainfallLabel,
          description: l10n.seasonSummaryInfoAverageRainfallDescription,
        ),
        InfoSheetItem(
          icon: Icons.trending_up,
          title: l10n.seasonSummaryTrendVsHistoryLabel,
          description: l10n.seasonSummaryInfoTrendVsHistoryDescription,
        ),
        InfoSheetItem(
          icon: Icons.arrow_circle_up_outlined,
          title: l10n.seasonSummaryHighestRecordedLabel,
          description: l10n.seasonSummaryInfoHighestRecordedDescription,
        ),
        InfoSheetItem(
          icon: Icons.arrow_circle_down_outlined,
          title: l10n.seasonSummaryLowestRecordedLabel,
          description: l10n.seasonSummaryInfoLowestRecordedDescription,
        ),
      ],
    );
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final AppLocalizations l10n = AppLocalizations.of(context);
    final MeasurementUnit unit =
        ref.watch(userPreferencesProvider).value?.measurementUnit ??
        MeasurementUnit.mm;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    l10n.seasonSummaryTitle,
                    style: textTheme.titleMedium,
                  ),
                ),
                AppIconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () => _showInfoSheet(context, l10n),
                  tooltip: l10n.infoTooltip,
                  iconSize: 20,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                runSpacing: 24,
                children: [
                  _MetricItem(
                    label: l10n.seasonSummaryAverageRainfallLabel,
                    value: summary.averageRainfall.formatRainfall(
                      context,
                      unit,
                    ),
                    valueStyle: textTheme.headlineSmall,
                  ),
                  _TrendMetricItem(
                    label: l10n.seasonSummaryTrendVsHistoryLabel,
                    percentage: summary.trendVsHistory,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                runSpacing: 24,
                children: [
                  _MetricItem(
                    label: l10n.seasonSummaryHighestRecordedLabel,
                    value: summary.highestRecorded.formatRainfall(
                      context,
                      unit,
                    ),
                  ),
                  _MetricItem(
                    label: l10n.seasonSummaryLowestRecordedLabel,
                    value: summary.lowestRecorded.formatRainfall(context, unit),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({
    required this.label,
    required this.value,
    this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle? valueStyle;

  @override
  Widget build(final BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(value, style: valueStyle ?? textTheme.titleLarge),
      ],
    );
  }
}

class _TrendMetricItem extends StatelessWidget {
  const _TrendMetricItem({required this.label, required this.percentage});

  final String label;
  final double percentage;

  @override
  Widget build(final BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isPositive = percentage >= 0;
    final Color color = isPositive ? colorScheme.tertiary : colorScheme.error;
    final IconData icon = isPositive ? Icons.trending_up : Icons.trending_down;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 8),
            Text(
              percentage.formatPercentage(precision: 0, showPositiveSign: true),
              style: textTheme.headlineSmall?.copyWith(color: color),
            ),
          ],
        ),
      ],
    );
  }
}
