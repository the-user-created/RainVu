import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:rainvu/core/utils/snackbar_service.dart";
import "package:rainvu/features/changelog/domain/changelog_entry.dart";
import "package:rainvu/l10n/app_localizations.dart";
import "package:url_launcher/url_launcher.dart";

class ChangeItemTile extends StatelessWidget {
  const ChangeItemTile({required this.item, required this.category, super.key});

  final ChangeItem item;
  final ChangeCategory category;

  Future<void> _launchUrl(
    final BuildContext context,
    final String urlString,
  ) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final Uri? url = Uri.tryParse(urlString);

    if (context.mounted) {
      try {
        if (url != null && await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          throw Exception("Could not launch URL: canLaunchUrl returned false.");
        }
      } catch (e, s) {
        FirebaseCrashlytics.instance.recordError(
          e,
          s,
          reason: "Changelog URL launch failure for: $urlString",
        );

        SnackbarService.instance.showSnackBar(
          l10n.urlLaunchError,
          type: MessageType.error,
        );
      }
    }
  }

  /// Parses a string with markdown and returns a list of [TextSpan]s.
  /// Supports `**bold**` text, `[link text](url)` links, and `` `code` ``.
  List<TextSpan> _buildTextSpans(
    final BuildContext context,
    final String text,
    final TextStyle baseStyle,
    final TextStyle boldStyle,
    final TextStyle linkStyle,
    final TextStyle codeStyle,
  ) {
    final List<TextSpan> spans = [];
    final RegExp markdownRegex = RegExp(
      r"\*\*(.*?)\*\*|\[(.*?)\]\((.*?)\)|`(.*?)`",
    );
    int lastMatchEnd = 0;

    for (final Match match in markdownRegex.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: text.substring(lastMatchEnd, match.start)));
      }

      final String? boldText = match.group(1);
      final String? linkText = match.group(2);
      final String? linkUrl = match.group(3);
      final String? codeText = match.group(4);

      if (boldText != null) {
        // Handle bold text
        spans.add(TextSpan(text: boldText, style: boldStyle));
      } else if (linkText != null && linkUrl != null) {
        // Handle link
        spans.add(
          TextSpan(
            text: linkText,
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () => _launchUrl(context, linkUrl),
          ),
        );
      } else if (codeText != null) {
        spans.add(
          TextSpan(
            text: " $codeText ",
            style: codeStyle,
          ),
        );
      }
      lastMatchEnd = match.end;
    }

    // Add any remaining text after the last match.
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd)));
    }

    // If no matches were found, return a single span.
    if (spans.isEmpty) {
      spans.add(TextSpan(text: text));
    }

    return spans;
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;
    final Color categoryColor = category.color(colorScheme);

    final TextStyle baseStyle = textTheme.bodyMedium!.copyWith(
      color: colorScheme.onSurfaceVariant,
      height: 1.5,
    );
    final TextStyle boldStyle = baseStyle.copyWith(
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurface,
    );
    final TextStyle linkStyle = baseStyle.copyWith(
      color: colorScheme.primary,
      decoration: TextDecoration.underline,
      decorationColor: colorScheme.primary,
    );
    final TextStyle codeStyle = textTheme.bodyMedium!.copyWith(
      fontFamily: GoogleFonts.robotoMono().fontFamily,
      backgroundColor: colorScheme.outlineVariant,
      color: colorScheme.onSurfaceVariant,
      fontSize: (textTheme.bodyMedium?.fontSize ?? 14) * 0.95,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4, right: 12),
            child: Icon(category.icon, size: 18, color: categoryColor),
          ),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: baseStyle,
                children: _buildTextSpans(
                  context,
                  item.description,
                  baseStyle,
                  boldStyle,
                  linkStyle,
                  codeStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
