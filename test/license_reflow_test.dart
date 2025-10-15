import "package:flutter/foundation.dart";
import "package:flutter_test/flutter_test.dart";
import "package:rainvu/oss_licenses.dart" as oss;

/// This is the same reflow method from your LicenseDetailScreen.
/// You could alternatively import it directly if you refactor it into a utility file.
String reflowLicenseText(final String text) {
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

    final bool isParagraphBreak =
        (currentLine.isEmpty && nextLineTrimmed.isNotEmpty) ||
        (nextLineTrimmed.isEmpty && currentLine.isNotEmpty);
    final bool isListItem = nextLineTrimmed.startsWith(
      RegExp(r"\*|•|- |[0-9]+\.|\([a-zA-Z0-9]+\)"),
    );
    final bool endsWithColon = currentLine.endsWith(":");
    final bool isDivider = RegExp(r"^(=+|-+|\*+|_+)$").hasMatch(currentLine);

    if (isParagraphBreak || isListItem || endsWithColon || isDivider) {
      buffer.write("\n");
    } else if (currentLine.isNotEmpty) {
      buffer.write(" ");
    }
  }
  return buffer.toString();
}

/// Utility: strip all whitespace/newlines so only semantic characters remain.
String normalizeForComparison(final String text) =>
    text.replaceAll(RegExp(r"\s+"), "");

void main() {
  test("Reflow does not change license semantic content", () {
    final List<oss.Package> packages = [...oss.allDependencies]
      ..sort(
        (final a, final b) =>
            a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );

    for (final pkg in packages) {
      final String? licenseText = pkg.license;

      if (licenseText == null) {
        if (kDebugMode) {
          print("Skipping package with no license: ${pkg.name}");
        }
        continue; // Some dependencies may not include a license.
      }

      final String reflowed = reflowLicenseText(licenseText);

      final String originalNorm = normalizeForComparison(licenseText);
      final String reflowedNorm = normalizeForComparison(reflowed);

      expect(
        reflowedNorm,
        equals(originalNorm),
        reason: "Reflow altered semantic content for package ${pkg.name}",
      );
    }
  });
}
