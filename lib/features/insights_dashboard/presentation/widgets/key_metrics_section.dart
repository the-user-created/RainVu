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
    final TextTheme textTheme = theme.textTheme;
    final AppLocalizations l10n = AppLocalizations.of(context);
    final Color successColor = colorScheme.tertiary;
    final Color errorColor = colorScheme.error;
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
            color: theme.shadowColor,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(l10n.keyMetricsTitle, style: textTheme.headlineSmall),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _MetricCard(
                  title: l10n.keyMetricsTotalRainfall,
                  value: metrics.totalRainfall.formatRainfall(context, unit),
                  changeText: l10n.keyMetricsTotalRainfallChange(
                    metrics.totalRainfallPrevYearChange.formatPercentage(
                      withSymbol: false,
                    ),
                  ),
                  changeColor: metrics.totalRainfallPrevYearChange >= 0
                      ? successColor
                      : errorColor,
                  onInfoPressed: () => InfoSheet.show(
                    context,
                    title: l10n.keyMetricsInfoTotalRainfallTitle,
                    items: [
                      InfoSheetItem(
                        icon: Icons.water_drop_outlined,
                        title: "", // Title is handled by the sheet's title
                        description:
                            l10n.keyMetricsInfoTotalRainfallDescription,
                      ),
                    ],
                  ),
                ),
                _MetricCard(
                  title: l10n.keyMetricsMtdTotal,
                  value: metrics.mtdTotal.formatRainfall(context, unit),
                  changeText: l10n.keyMetricsMtdChange(
                    metrics.mtdTotalPrevMonthChange.formatPercentage(
                      withSymbol: false,
                    ),
                  ),
                  changeColor: metrics.mtdTotalPrevMonthChange >= 0
                      ? successColor
                      : errorColor,
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
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _MetricCard(
                  title: l10n.keyMetricsYtdTotal,
                  value: metrics.ytdTotal.formatRainfall(context, unit),
                  changeText: l10n.keyMetricsYtdChange(
                    metrics.ytdTotalPrevYearChange.formatPercentage(
                      withSymbol: false,
                    ),
                  ),
                  changeColor: metrics.ytdTotalPrevYearChange >= 0
                      ? successColor
                      : errorColor,
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
                _MetricCard(
                  title: l10n.keyMetricsMonthlyAvg,
                  value: metrics.monthlyAvg.formatRainfall(context, unit),
                  changeText: l10n.keyMetricsMonthlyAvgSource,
                  changeColor: colorScheme.onSurfaceVariant,
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.changeText,
    required this.changeColor,
    required this.onInfoPressed,
  });

  final String title;
  final String value;
  final String changeText;
  final Color changeColor;
  final VoidCallback onInfoPressed;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final double cardWidth = MediaQuery.sizeOf(context).width * 0.42;

    return Card(
      elevation: 2,
      color: colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: cardWidth,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(child: Text(title, style: textTheme.bodyMedium)),
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
            Text(
              value,
              style: textTheme.headlineMedium?.copyWith(fontSize: 26),
            ),
            const SizedBox(height: 8),
            Text(
              changeText,
              style: textTheme.bodySmall?.copyWith(color: changeColor),
            ),
          ],
        ),
      ),
    );
  }
}
