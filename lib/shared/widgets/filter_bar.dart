import "package:flutter/material.dart";

/// A dedicated bar for displaying filter controls, typically placed below an AppBar.
class FilterBar extends StatelessWidget {
  const FilterBar({required this.child, super.key});

  /// The filter widget(s) to be displayed inside the bar.
  final Widget child;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        border: Border(
          bottom: BorderSide(color: theme.dividerColor, width: 0.5),
        ),
      ),
      child: child,
    );
  }
}
