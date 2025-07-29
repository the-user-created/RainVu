import "package:flutter/material.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

class PlanFeatureTile extends StatelessWidget {
  const PlanFeatureTile({
    required this.text,
    required this.isIncluded,
    super.key,
  });

  final String text;
  final bool isIncluded;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    return Row(
      children: [
        Icon(
          isIncluded ? Icons.check_circle : Icons.remove_circle_outline,
          color: isIncluded ? theme.primary : theme.error,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: theme.bodyMedium.override(
              color: isIncluded ? theme.primaryText : theme.secondaryText,
            ),
          ),
        ),
      ],
    );
  }
}
