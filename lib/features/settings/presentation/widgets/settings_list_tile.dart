import "package:flutter/material.dart";

/// A reusable, tappable list tile for a single setting item.
/// It uses a standard [ListTile] for consistency and accessibility.
class SettingsListTile extends StatelessWidget {
  const SettingsListTile({
    required this.title,
    super.key,
    this.onTap,
  });

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ListTile(
      title: Text(
        title,
        style: theme.textTheme.titleLarge,
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: theme.colorScheme.onSurfaceVariant,
        size: 24,
      ),
      onTap: onTap,
    );
  }
}
