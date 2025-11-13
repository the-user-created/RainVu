import "package:flutter/material.dart";

/// A dedicated bar for displaying filter controls, typically placed below an AppBar.
class GaugeFilterBar extends StatelessWidget {
  const GaugeFilterBar({required this.child, super.key});

  /// The filter widget to be displayed inside the bar, e.g., a Dropdown.
  final Widget child;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
