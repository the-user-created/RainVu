import "package:flutter/material.dart";
import "package:rain_wise/features/insights/domain/anomaly_data.dart";
import "package:rain_wise/features/insights/presentation/widgets/anomaly_exploration/anomaly_list_item.dart";
import "package:rain_wise/l10n/app_localizations.dart";

class AnomalyList extends StatelessWidget {
  const AnomalyList({
    required this.anomalies,
    super.key,
  });

  final List<RainfallAnomaly> anomalies;

  @override
  Widget build(final BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.detectedAnomaliesTitle, style: textTheme.titleMedium),
          const SizedBox(height: 12),
          if (anomalies.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.noAnomaliesFound,
                  style: textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ListView.separated(
              padding: EdgeInsets.zero,
              primary: false,
              shrinkWrap: true,
              itemCount: anomalies.length,
              itemBuilder: (final context, final index) => AnomalyListItem(
                anomaly: anomalies[index],
              ),
              separatorBuilder: (final context, final index) =>
                  const SizedBox(height: 12),
            ),
        ],
      ),
    );
  }
}
