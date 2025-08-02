import "package:flutter/material.dart";

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
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;
    return ExpansionTile(
      title: Text(question, style: textTheme.bodyLarge),
      iconColor: colorScheme.onSurface,
      collapsedIconColor: colorScheme.onSurface,
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        Text(
          answer,
          style: textTheme.bodyMedium
              ?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
