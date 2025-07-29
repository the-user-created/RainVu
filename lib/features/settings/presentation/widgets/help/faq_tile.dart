import "package:flutter/material.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

/// An expandable tile for displaying a Frequently Asked Question.
class FaqTile extends StatelessWidget {
  const FaqTile({
    required this.question,
    required this.answer,
    super.key,
  });

  final String question;
  final String answer;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    return ExpansionTile(
      title: Text(question, style: theme.bodyLarge),
      iconColor: theme.primaryText,
      collapsedIconColor: theme.primaryText,
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        Text(
          answer,
          style: theme.bodyMedium.copyWith(color: theme.secondaryText),
        ),
      ],
    );
  }
}
