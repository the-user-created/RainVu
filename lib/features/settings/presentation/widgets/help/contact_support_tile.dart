import "package:flutter/material.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
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
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    return ListTile(
      onTap: () => _launchUrl(context),
      title: Text(title, style: theme.bodyLarge),
      subtitle: Text(
        subtitle,
        style: theme.bodyMedium.copyWith(color: theme.primary),
      ),
      trailing: Icon(icon, color: theme.primary, size: 24),
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    );
  }
}
