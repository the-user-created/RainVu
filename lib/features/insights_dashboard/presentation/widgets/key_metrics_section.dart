import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/application/preferences_provider.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/insights_dashboard/domain/insights_data.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/user_preferences.dart";
import "package:rain_wise/shared/widgets/buttons/app_icon_button.dart";
import "package:rain_wise/shared/widgets/sheets/info_sheet.dart";

class KeyMetricsSection extends ConsumerWidget {
  const KeyMetricsSection({required this.metrics, super.key});

  final KeyMetrics metrics;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = AppLocalizations.of(context);
    final MeasurementUnit unit =
        ref.watch(userPreferencesProvider).value?.measurementUnit ??
        MeasurementUnit.mm;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: theme.shadowColor.withValues(alpha: 0.2),
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _KeyMetricCard(
            title: l10n.keyMetricsMtdTotal,
            metric: metrics.mtdTotal,
            unit: unit,
            change: metrics.mtdTotalPrevMonthChange,
            changeLabel: l10n.keyMetricsComparisonVsLastMonth,
            onInfoPressed: () => InfoSheet.show(
              context,
              title: l10n.keyMetricsInfoMtdTotalTitle,
              items: [
                InfoSheetItem(
                  icon: Icons.calendar_view_month_outlined,
                  title: "",
                  description: l10n.keyMetricsInfoMtdTotalDescription,
                ),
              ],
            ),
          ),
          _KeyMetricCard(
            title: l10n.keyMetricsYtdTotal,
            metric: metrics.ytdTotal,
            unit: unit,
            change: metrics.ytdTotalPrevYearChange,
            changeLabel: l10n.keyMetricsComparisonVsLastYear,
            onInfoPressed: () => InfoSheet.show(
              context,
              title: l10n.keyMetricsInfoYtdTotalTitle,
              items: [
                InfoSheetItem(
                  icon: Icons.calendar_today_outlined,
                  title: "",
                  description: l10n.keyMetricsInfoYtdTotalDescription,
                ),
              ],
            ),
          ),
          _KeyMetricCard(
            title: l10n.keyMetricsMonthlyAvg,
            metric: metrics.monthlyAvg,
            unit: unit,
            change: metrics.monthlyAvgChangeVsCurrentMonth,
            changeLabel: l10n.keyMetricsComparisonVsAvg,
            onInfoPressed: () => InfoSheet.show(
              context,
              title: l10n.keyMetricsInfoMonthlyAvgTitle,
              items: [
                InfoSheetItem(
                  icon: Icons.multiline_chart_outlined,
                  title: "",
                  description: l10n.keyMetricsInfoMonthlyAvgDescription,
                ),
              ],
            ),
          ),
          _KeyMetricCard(
            title: l10n.keyMetricsTotalRainfall,
            metric: metrics.totalRainfall,
            unit: unit,
            change: metrics.totalRainfallPrevYearChange,
            changeLabel: l10n.keyMetricsComparisonVsLastYear,
            onInfoPressed: () => InfoSheet.show(
              context,
              title: l10n.keyMetricsInfoTotalRainfallTitle,
              items: [
                InfoSheetItem(
                  icon: Icons.water_drop_outlined,
                  title: "",
                  description: l10n.keyMetricsInfoTotalRainfallDescription,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KeyMetricCard extends StatelessWidget {
  const _KeyMetricCard({
    required this.title,
    required this.metric,
    required this.unit,
    required this.change,
    required this.changeLabel,
    required this.onInfoPressed,
  });

  final String title;
  final double metric;
  final MeasurementUnit unit;
  final double change;
  final String changeLabel;
  final VoidCallback onInfoPressed;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final AppLocalizations l10n = AppLocalizations.of(context);

    final bool isPositiveChange = change >= 0;
    final Color changeColor = isPositiveChange
        ? colorScheme.tertiary
        : colorScheme.error;
    final IconData changeIcon = isPositiveChange
        ? Icons.arrow_upward
        : Icons.arrow_downward;
    final String formattedPercentage = change.abs().formatPercentage(
      precision: 0,
    );
    final String formattedValue = metric.formatRainfall(
      context,
      unit,
      withUnit: false,
    );
    final String unitLabel = unit == MeasurementUnit.mm
        ? l10n.unitMM
        : l10n.unitIn;

    return Card(
      elevation: 2,
      color: colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              // Using mainAxisSize to prevent the Row from expanding unnecessarily
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(child: Text(title, style: textTheme.titleSmall)),
                const SizedBox(width: 8),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: AppIconButton(
                    icon: Icon(
                      Icons.info_outline,
                      color: colorScheme.secondary,
                      size: 20,
                    ),
                    onPressed: onInfoPressed,
                    tooltip: l10n.infoTooltip,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(formattedValue, style: textTheme.headlineMedium),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    unitLabel,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(changeIcon, color: changeColor, size: 16),
                const SizedBox(width: 4),
                Text(
                  formattedPercentage,
                  style: textTheme.bodySmall?.copyWith(color: changeColor),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    changeLabel,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
