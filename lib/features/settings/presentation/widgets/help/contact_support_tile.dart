import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:rain_wise/core/utils/snackbar_service.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/utils/ui_helpers.dart";
import "package:url_launcher/url_launcher.dart";

/// A tappable tile for contacting support, which launches a URL (e.g., mailto).
/// Includes a press-and-hold scale animation for responsive feedback.
class ContactSupportTile extends StatefulWidget {
  const ContactSupportTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.url,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String url;

  @override
  State<ContactSupportTile> createState() => _ContactSupportTileState();
}

class _ContactSupportTileState extends State<ContactSupportTile> {
  bool _isPressed = false;

  Future<void> _launchUrl(final BuildContext context) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final Uri uri = Uri.parse(widget.url);
    if (!await launchUrl(uri)) {
      if (!context.mounted) {
        return;
      }
      showSnackbar(
        l10n.helpCouldNotOpenUrl(widget.url),
        type: MessageType.error,
      );
    }
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;
    return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _launchUrl(context),
            onHighlightChanged: (final isHighlighted) {
              setState(() => _isPressed = isHighlighted);
            },
            child: ListTile(
              title: Text(widget.title, style: textTheme.bodyLarge),
              subtitle: Text(
                widget.subtitle,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.secondary,
                ),
              ),
              trailing: Icon(
                widget.icon,
                color: colorScheme.secondary,
                size: 24,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
            ),
          ),
        )
        .animate(target: _isPressed ? 1 : 0)
        .scaleXY(end: 0.98, duration: 150.ms, curve: Curves.easeOut);
  }
}
