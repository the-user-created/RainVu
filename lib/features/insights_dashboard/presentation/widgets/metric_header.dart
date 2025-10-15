import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rainvu/core/application/preferences_provider.dart";
import "package:rainvu/core/utils/extensions.dart";
import "package:rainvu/features/insights_dashboard/application/insights_providers.dart";
import "package:rainvu/features/insights_dashboard/domain/insights_data.dart";
import "package:rainvu/l10n/app_localizations.dart";
import "package:rainvu/shared/domain/user_preferences.dart";
import "package:rainvu/shared/widgets/forms/app_choice_chips.dart";

class MetricHeader extends ConsumerWidget {
  const MetricHeader({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final DashboardMetric metric = ref.watch(dashboardMetricStateProvider);
    final MetricData? metricData = ref.watch(currentMetricDataProvider);

    final List<ChipOption<DashboardMetric>> chipOptions = [
      ChipOption(value: DashboardMetric.mtd, label: l10n.dashboardMetricMTD),
      ChipOption(value: DashboardMetric.ytd, label: l10n.dashboardMetricYTD),
      ChipOption(
        value: DashboardMetric.last12Months,
        label: l10n.dashboardMetric12Mo,
      ),
      ChipOption(
        value: DashboardMetric.allTime,
        label: l10n.dashboardMetricAllTime,
      ),
    ];

    return Column(
      children: [
        if (metricData != null) _MetricDisplay(metricData: metricData),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AppChoiceChips<DashboardMetric>(
            options: chipOptions,
            selectedValue: metric,
            onSelected: (final value) => ref
                .read(dashboardMetricStateProvider.notifier)
                .setMetric(value),
            alignment: WrapAlignment.center,
          ),
        ),
      ],
    );
  }
}

class _MetricDisplay extends ConsumerWidget {
  const _MetricDisplay({required this.metricData});

  final MetricData metricData;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final MeasurementUnit unit =
        ref.watch(userPreferencesProvider).value?.measurementUnit ??
        MeasurementUnit.mm;
    final bool isPositive = metricData.changePercentage >= 0;

    final String changeLabel;
    switch (metricData.changeLabel) {
      case "dashboardComparisonVsPrevious":
        changeLabel = l10n.dashboardComparisonVsPrevious;
      case "dashboardComparisonVsAverage":
        changeLabel = l10n.dashboardComparisonVsAverage;
      default:
        changeLabel = metricData.changeLabel;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            metricData.primaryValue.formatRainfall(context, unit),
            style: theme.textTheme.displayMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
          ),
        ),
        const SizedBox(height: 4),
        if (metricData.changePercentage != 0)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: metricData.changePercentage.formatPercentage(
                          precision: 0,
                          showPositiveSign: true,
                        ),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isPositive
                              ? theme.colorScheme.tertiary
                              : theme.colorScheme.error,
                        ),
                      ),
                      TextSpan(
                        text: " $changeLabel",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
