import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:rain_wise/features/unusual_patterns/domain/unusual_patterns_data.dart";
import "package:rain_wise/features/unusual_patterns/presentation/widgets/unusual_patterns_list_item.dart";
import "package:rain_wise/l10n/app_localizations.dart";

class AnomalyList extends StatelessWidget {
  const AnomalyList({
    required this.anomalies,
    required this.chartPoints,
    super.key,
  });

  final List<RainfallAnomaly> anomalies;
  final List<AnomalyChartPoint> chartPoints;

  Map<DateTime, List<RainfallAnomaly>> _groupAnomaliesByMonth(
    final List<RainfallAnomaly> anomalies,
  ) => groupBy(
    anomalies,
    (final anomaly) => DateTime(anomaly.date.year, anomaly.date.month),
  );

  @override
  Widget build(final BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final AppLocalizations l10n = AppLocalizations.of(context);

    if (anomalies.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Text(
              l10n.noAnomaliesFound,
              style: textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final Map<DateTime, List<RainfallAnomaly>> groupedAnomalies =
        _groupAnomaliesByMonth(anomalies);
    final List<DateTime> sortedMonths = groupedAnomalies.keys.toList()
      ..sort((final a, final b) => b.compareTo(a));

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(
            child: Text(
              l10n.detectedAnomaliesTitle,
              style: textTheme.titleMedium,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverList.separated(
            itemCount: sortedMonths.length,
            separatorBuilder: (final context, final index) =>
                const SizedBox(height: 12),
            itemBuilder: (final context, final index) {
              final DateTime month = sortedMonths[index];
              final List<RainfallAnomaly> monthAnomalies =
                  groupedAnomalies[month]!;

              // Calculate monthly summary stats
              final List<AnomalyChartPoint> monthChartPoints = chartPoints
                  .where(
                    (final p) =>
                        p.date.year == month.year &&
                        p.date.month == month.month,
                  )
                  .toList();
              final double totalActual = monthChartPoints
                  .map((final p) => p.actualRainfall)
                  .sum;
              final double totalAverage = monthChartPoints
                  .map((final p) => p.averageRainfall)
                  .sum;

              return _AnomalyGroup(
                month: month,
                anomalies: monthAnomalies,
                totalActualRainfall: totalActual,
                totalAverageRainfall: totalAverage,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AnomalyGroup extends StatefulWidget {
  const _AnomalyGroup({
    required this.month,
    required this.anomalies,
    required this.totalActualRainfall,
    required this.totalAverageRainfall,
  });

  final DateTime month;
  final List<RainfallAnomaly> anomalies;
  final double totalActualRainfall;
  final double totalAverageRainfall;

  @override
  State<_AnomalyGroup> createState() => _AnomalyGroupState();
}

class _AnomalyGroupState extends State<_AnomalyGroup> {
  bool _isExpanded = false;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final AppLocalizations l10n = AppLocalizations.of(context);

    final double deviation =
        widget.totalActualRainfall - widget.totalAverageRainfall;
    final double percentage = widget.totalAverageRainfall > 0
        ? (deviation / widget.totalAverageRainfall) * 100
        : 0;
    final bool isPositive = deviation >= 0;
    final Color deviationColor = isPositive
        ? colorScheme.tertiary
        : colorScheme.error;

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  AnimatedRotation(
                    turns: _isExpanded ? 0.25 : 0.0,
                    duration: const Duration(milliseconds: 150),
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat.yMMMM().format(widget.month),
                          style: textTheme.titleMedium,
                        ),
                        Text(
                          l10n.anomalyGroupSummary(widget.anomalies.length),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (percentage.abs() > 0) ...[
                          const SizedBox(height: 4),
                          Text(
                            l10n.anomalyGroupDeviation(
                              isPositive ? "+" : "",
                              percentage.abs().toStringAsFixed(0),
                            ),
                            style: textTheme.bodyMedium?.copyWith(
                              color: deviationColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: _isExpanded
                ? Column(
                    children: [
                      const Divider(height: 1),
                      ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.anomalies.length,
                        itemBuilder: (final context, final index) =>
                            AnomalyListItem(anomaly: widget.anomalies[index]),
                        separatorBuilder: (final context, final index) =>
                            const Divider(indent: 16, endIndent: 16, height: 1),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
