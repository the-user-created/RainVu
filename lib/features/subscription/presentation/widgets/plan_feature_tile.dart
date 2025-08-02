import "package:flutter/material.dart";

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
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return Row(
      children: [
        Icon(
          isIncluded ? Icons.check_circle : Icons.remove_circle_outline,
          color: isIncluded ? colorScheme.secondary : colorScheme.error,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isIncluded
                  ? colorScheme.onSurface
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
