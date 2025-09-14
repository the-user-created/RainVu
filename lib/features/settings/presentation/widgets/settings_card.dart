import "package:flutter/material.dart";
import "package:rain_wise/app_constants.dart";

/// A styled card that wraps a list of setting tiles.
/// It provides a consistent background, shadow, and dividers.
class SettingsCard extends StatelessWidget {
  const SettingsCard({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horiEdgePadding,
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shadowColor: theme.cardTheme.shadowColor,
        color: theme.colorScheme.surface,
        margin: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: ListTile.divideTiles(
            context: context,
            tiles: children,
            color: theme.colorScheme.outlineVariant,
          ).toList(),
        ),
      ),
    );
  }
}
