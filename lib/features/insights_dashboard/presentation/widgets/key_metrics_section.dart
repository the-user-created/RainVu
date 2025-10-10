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
            color: theme.shadowColor.withValues(alpha: 0.2),
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: LayoutBuilder(
          builder: (final context, final constraints) {
            final bool isWideLayout = constraints.maxWidth > 600;

            final List<Widget> metricCards = [
              _MetricCard(
                isCompact: isWideLayout,
                title: l10n.keyMetricsTotalRainfall,
                rawValue: metrics.totalRainfall,
                unit: unit,
                changeValue: metrics.totalRainfallPrevYearChange,
                changeLabel: l10n.keyMetricsComparisonVsLastYear,
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
                      description: l10n.keyMetricsInfoTotalRainfallDescription,
                    ),
                  ],
                ),
              ),
              _MetricCard(
                isCompact: isWideLayout,
                title: l10n.keyMetricsMtdTotal,
                rawValue: metrics.mtdTotal,
                unit: unit,
                changeValue: metrics.mtdTotalPrevMonthChange,
                changeLabel: l10n.keyMetricsComparisonVsLastMonth,
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
              _MetricCard(
                isCompact: isWideLayout,
                title: l10n.keyMetricsYtdTotal,
                rawValue: metrics.ytdTotal,
                unit: unit,
                changeValue: metrics.ytdTotalPrevYearChange,
                changeLabel: l10n.keyMetricsComparisonVsLastYear,
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
                isCompact: isWideLayout,
                title: l10n.keyMetricsMonthlyAvg,
                rawValue: metrics.monthlyAvg,
                unit: unit,
                changeValue: metrics.monthlyAvgChangeVsCurrentMonth,
                changeLabel: l10n.keyMetricsComparisonVsAvg,
                changeColor: metrics.monthlyAvgChangeVsCurrentMonth >= 0
                    ? successColor
                    : errorColor,
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
            ];

            return isWideLayout
                ? _buildLandscapeLayout(metricCards)
                : _buildPortraitLayout(context, metricCards);
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(
    final BuildContext context,
    final List<Widget> cards,
  ) {
    const double horizontalPadding = 8 * 2;
    const double cardSpacing = 4;
    final double cardWidth =
        (MediaQuery.sizeOf(context).width - horizontalPadding - cardSpacing) /
        2;

    return Wrap(
      spacing: cardSpacing,
      runSpacing: cardSpacing,
      alignment: WrapAlignment.center,
      children: cards
          .map((final card) => SizedBox(width: cardWidth, child: card))
          .toList(),
    );
  }

  Widget _buildLandscapeLayout(final List<Widget> cards) =>
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: cards
              .map(
                (final card) => ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 220),
                  child: card,
                ),
              )
              .toList()
              .divide(const SizedBox(width: 8)),
        ),
      );
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.rawValue,
    required this.unit,
    required this.changeValue,
    required this.changeLabel,
    required this.changeColor,
    required this.onInfoPressed,
    this.isCompact = false,
  });

  final String title;
  final double rawValue;
  final MeasurementUnit unit;
  final double changeValue;
  final String changeLabel;
  final Color changeColor;
  final VoidCallback onInfoPressed;
  final bool isCompact;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    final String formattedValue = rawValue.formatRainfall(
      context,
      unit,
      withUnit: false,
    );

    final String unitLabel = unit == MeasurementUnit.mm
        ? l10n.unitMM
        : l10n.unitIn;

    final IconData changeIcon = changeValue >= 0
        ? Icons.arrow_upward
        : Icons.arrow_downward;

    final String formattedPercentage = changeValue.abs().formatPercentage(
      precision: 0,
    );

    return Card(
      elevation: 2,
      color: colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: textTheme.titleSmall?.copyWith(
                      fontSize: isCompact ? 14 : null,
                    ),
                  ),
                ),
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
            SizedBox(height: isCompact ? 8 : 8),
            if (isCompact)
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    formattedValue,
                    style: textTheme.headlineMedium?.copyWith(fontSize: 24),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    unitLabel,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              )
            else ...[
              Text(
                formattedValue,
                style: textTheme.headlineMedium?.copyWith(fontSize: 26),
              ),
              const SizedBox(height: 2),
              Text(
                unitLabel,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            SizedBox(height: isCompact ? 8 : 8),
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
