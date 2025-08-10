import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:rain_wise/features/insights/domain/anomaly_data.dart";
import "package:rain_wise/l10n/app_localizations.dart";

class AnomalyListItem extends StatelessWidget {
  const AnomalyListItem({
    required this.anomaly,
    super.key,
  });

  final RainfallAnomaly anomaly;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final AppLocalizations l10n = AppLocalizations.of(context);

    final String sign = anomaly.deviationPercentage > 0 ? "+" : "";
    final String deviationValue =
        "$sign${anomaly.deviationPercentage.toStringAsFixed(0)}";
    final String deviationText = l10n.anomalyDeviationVsAverage(deviationValue);

    return InkWell(
      onTap: () {
        // TODO: Navigate to a dedicated detail view for this anomaly
      },
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat.yMMMd().format(anomaly.date),
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  _SeverityBadge(
                    text: deviationText,
                    color: anomaly.severity.color,
                    backgroundColor: anomaly.severity.backgroundColor,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                anomaly.description,
                style: textTheme.bodyMedium
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SeverityBadge extends StatelessWidget {
  const _SeverityBadge({
    required this.text,
    required this.color,
    required this.backgroundColor,
  });

  final String text;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(final BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          text,
          style: textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
