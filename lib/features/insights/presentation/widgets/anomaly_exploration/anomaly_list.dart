import "package:flutter/material.dart";
import "package:rain_wise/features/insights/domain/anomaly_data.dart";
import "package:rain_wise/features/insights/presentation/widgets/anomaly_exploration/anomaly_list_item.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

class AnomalyList extends StatelessWidget {
  const AnomalyList({
    required this.anomalies,
    super.key,
  });

  final List<RainfallAnomaly> anomalies;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Detected Anomalies", style: theme.titleMedium),
          const SizedBox(height: 12),
          if (anomalies.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "No anomalies found for the selected filters.",
                  style: theme.bodyLarge,
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
