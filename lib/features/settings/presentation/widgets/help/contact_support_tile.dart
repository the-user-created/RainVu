import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";

/// A tappable tile for contacting support, which launches a URL (e.g., mailto).
class ContactSupportTile extends StatelessWidget {
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

  Future<void> _launchUrl(final BuildContext context) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open $url")),
      );
    }
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;
    return ListTile(
      onTap: () => _launchUrl(context),
      title: Text(title, style: textTheme.bodyLarge),
      subtitle: Text(
        subtitle,
        style: textTheme.bodyMedium?.copyWith(color: colorScheme.secondary),
      ),
      trailing: Icon(icon, color: colorScheme.secondary, size: 24),
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    );
  }
}
