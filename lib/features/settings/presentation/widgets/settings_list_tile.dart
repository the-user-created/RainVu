import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";

/// A reusable, tappable list tile for a single setting item.
/// It uses a standard [ListTile] for consistency and accessibility, with a
/// press-and-hold scale animation for responsive feedback.
class SettingsListTile extends StatefulWidget {
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
  State<SettingsListTile> createState() => _SettingsListTileState();
}

class _SettingsListTileState extends State<SettingsListTile> {
  bool _isPressed = false;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            onHighlightChanged: (final isHighlighted) {
              setState(() => _isPressed = isHighlighted);
            },
            child: ListTile(
              leading: widget.leading != null
                  ? IconTheme(
                      data: IconThemeData(
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                      child: widget.leading!,
                    )
                  : null,
              title: Text(widget.title, style: theme.textTheme.bodyLarge),
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ),
          ),
        )
        .animate(target: _isPressed ? 1 : 0)
        .scaleXY(end: 0.98, duration: 150.ms, curve: Curves.easeOut);
  }
}
