import "package:flutter/material.dart";

/// Defines custom semantic color properties not available in the standard
/// [ColorScheme].
extension CustomColors on ColorScheme {
  /// A color for positive or successful states.
  /// Mapped from the legacy `success` color.
  Color get success => const Color(0xFF1B7F7A);

  // --- Changelog Semantic Colors ---

  /// A mossy green for new features.
  Color get changelogAdded => brightness == Brightness.dark
      ? const Color(0xFFA5D6A7)
      : const Color(0xFF6A994E);

  /// A warm, terracotta orange for modifications.
  Color get changelogChanged => brightness == Brightness.dark
      ? const Color(0xFFFFCC80)
      : const Color(0xFFBC6C25);

  /// A calming, deep slate blue for bug fixes.
  Color get changelogFixed => brightness == Brightness.dark
      ? const Color(0xFF90A4AE)
      : const Color(0xFF283655);

  /// An earthy red-brown for removals and breaking changes.
  Color get changelogRemoved => brightness == Brightness.dark
      ? const Color(0xFFEF9A9A)
      : const Color(0xFF9A4938);
}
