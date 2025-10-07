import "dart:math";

import "package:flutter/material.dart";
import "package:rain_wise/features/anomaly_exploration/domain/anomaly_data.dart";
import "package:rain_wise/features/anomaly_exploration/presentation/widgets/anomaly_list_item.dart";
import "package:rain_wise/l10n/app_localizations.dart";

class AnomalyList extends StatelessWidget {
  const AnomalyList({required this.anomalies, super.key});

  final List<RainfallAnomaly> anomalies;

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

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              l10n.detectedAnomaliesTitle,
              style: textTheme.titleMedium,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList.builder(
            itemCount: max(0, anomalies.length * 2 - 1),
            itemBuilder: (final context, final index) {
              if (index.isOdd) {
                // Return a separator
                return const SizedBox(height: 12);
              }
              // Return an item
              final int itemIndex = index ~/ 2;
              return AnomalyListItem(anomaly: anomalies[itemIndex]);
            },
          ),
        ),
      ],
    );
  }
}
