import "package:flutter/material.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/oss_licenses.dart" as oss;

class LicenseDetailScreen extends StatelessWidget {
  const LicenseDetailScreen({required this.package, super.key});

  final oss.Package package;

  /// This reformats license text to improve readability by intelligently
  /// handling line breaks.
  String _reflowLicenseText(final String text) {
    final List<String> lines = text.split("\n");
    final buffer = StringBuffer();

    for (int i = 0; i < lines.length; i++) {
      final String currentLine = lines[i].trim();
      buffer.write(currentLine);

      if (i == lines.length - 1) {
        break;
      }

      final String nextLine = lines[i + 1];
      final String nextLineTrimmed = nextLine.trim();

      // Determine if the current line break is structural ("hard")
      final bool isParagraphBreak =
          (currentLine.isEmpty && nextLineTrimmed.isNotEmpty) ||
          (nextLineTrimmed.isEmpty && currentLine.isNotEmpty);
      final bool isListItem = nextLineTrimmed.startsWith(
        RegExp(r"\*|•|- |[0-9]+\.|\([a-zA-Z0-9]+\)"),
      );
      final bool endsWithColon = currentLine.endsWith(":");
      final bool isDivider = RegExp(r"^(=+|-+|\*+|_+)$").hasMatch(currentLine);

      if (isParagraphBreak || isListItem || endsWithColon || isDivider) {
        // This is a structural break, so preserve the newline.
        buffer.write("\n");
      } else if (currentLine.isNotEmpty) {
        // This is a soft break (part of a flowing paragraph).
        buffer.write(" ");
      }
    }
    return buffer.toString();
  }

  void _showDisclaimer(final BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (final context) => AlertDialog(
        title: Text(l10n.licenseDisclaimerTitle),
        content: Text(l10n.licenseDisclaimerContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(MaterialLocalizations.of(context).okButtonLabel),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String licenseText = package.license ?? "License text not available.";
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(package.name),
        elevation: 2,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.info_outline, size: 28),
              tooltip: l10n.licenseDisclaimerTitle,
              onPressed: () => _showDisclaimer(context),
            ),
          ),
        ],
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: SelectableText(
            _reflowLicenseText(licenseText),
            style: theme.textTheme.bodyMedium!.copyWith(
              fontFamily: "monospace",
            ),
          ),
        ),
      ),
    );
  }
}
