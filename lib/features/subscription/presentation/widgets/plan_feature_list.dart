import "package:flutter/material.dart";
import "package:rain_wise/features/subscription/presentation/widgets/plan_feature_tile.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";

class PlanFeatureList extends StatelessWidget {
  const PlanFeatureList({
    super.key,
    this.includedFeatures = const [],
    this.excludedFeatures = const [],
  });

  final List<String> includedFeatures;
  final List<String> excludedFeatures;

  @override
  Widget build(final BuildContext context) => Column(
        children: [
          ...includedFeatures.map(
            (final feature) => PlanFeatureTile(text: feature, isIncluded: true),
          ),
          ...excludedFeatures.map(
            (final feature) =>
                PlanFeatureTile(text: feature, isIncluded: false),
          ),
        ].divide(const SizedBox(height: 8)),
      );
}
