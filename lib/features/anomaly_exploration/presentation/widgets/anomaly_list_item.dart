import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rain_wise/core/application/preferences_provider.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/anomaly_exploration/domain/anomaly_data.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/user_preferences.dart";

class AnomalyListItem extends ConsumerWidget {
  const AnomalyListItem({required this.anomaly, super.key});

  final RainfallAnomaly anomaly;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final AppLocalizations l10n = AppLocalizations.of(context);
    final MeasurementUnit unit =
        ref.watch(userPreferencesProvider).value?.measurementUnit ??
        MeasurementUnit.mm;

    final String sign = anomaly.deviationPercentage > 0 ? "+" : "";
    final String deviationValue =
        "$sign${anomaly.deviationPercentage.formatPercentage(precision: 0)}";
    final String deviationText = l10n.anomalyDeviationVsAverage(deviationValue);

    final String description;
    final String formattedAverage = anomaly.averageRainfall.formatRainfall(
      context,
      unit,
    );
    if (anomaly.deviationPercentage > 0) {
      description = l10n.anomalyDescriptionHigher(
        anomaly.deviationPercentage.formatPercentage(
          precision: 0,
          withSymbol: false,
        ),
        formattedAverage,
      );
    } else {
      description = l10n.anomalyDescriptionLower(
        anomaly.deviationPercentage.abs().formatPercentage(
          precision: 0,
          withSymbol: false,
        ),
        formattedAverage,
      );
    }

    return Card(
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
              description,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
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
