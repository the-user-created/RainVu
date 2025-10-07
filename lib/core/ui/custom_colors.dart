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

  // --- Changelog UI Element Colors ---

  /// A soft, off-white/beige background for a natural feel.
  Color get changelogBackground => brightness == Brightness.dark
      ? const Color(0xFF212121)
      : const Color(0xFFF8F6F2);

  /// The background for individual changelog cards.
  Color get changelogCardBackground => brightness == Brightness.dark
      ? const Color(0xFF2C2C2C)
      : const Color(0xFFFFFFFF);

  /// A soft color for dividers that complements the background.
  Color get changelogDivider => brightness == Brightness.dark
      ? const Color(0xFF424242)
      : const Color(0xFFDEDCD7);
}
