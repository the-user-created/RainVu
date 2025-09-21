import "package:flutter/material.dart";

/// A reusable, tappable list tile for a single setting item.
/// It uses a standard [ListTile] for consistency and accessibility.
class SettingsListTile extends StatelessWidget {
  const SettingsListTile({
    required this.title,
    super.key,
    this.leading,
    this.onTap,
  });

  final String title;
  final Widget? leading;
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ListTile(
      leading: leading != null
          ? IconTheme(
              data: IconThemeData(
                color: theme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              child: leading!,
            )
          : null,
      title: Text(title, style: theme.textTheme.bodyLarge),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: theme.colorScheme.onSurfaceVariant,
        size: 24,
      ),
      onTap: onTap,
    );
  }
}
