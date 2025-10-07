import "package:flutter/material.dart";

/// Defines custom semantic color properties not available in the standard
/// [ColorScheme].
extension CustomColors on ColorScheme {
  /// A color for positive or successful states.
  /// Mapped from the legacy `success` color.
  Color get success => const Color(0xFF1B7F7A);

  // --- Changelog Semantic Colors ---

  /// A mossy green for new features.
  Color get changelogAdded => const Color(0xFF6A994E);

  /// A warm, terracotta orange for modifications.
  Color get changelogChanged => const Color(0xFFBC6C25);

  /// A calming, deep slate blue for bug fixes.
  Color get changelogFixed => const Color(0xFF283655);

  /// An earthy red-brown for removals and breaking changes.
  Color get changelogRemoved => const Color(0xFF9A4938);

  // --- Changelog UI Element Colors ---

  /// A soft, off-white/beige background for a natural feel.
  Color get changelogBackground => const Color(0xFFF8F6F2);

  /// The background for individual changelog cards.
  Color get changelogCardBackground => const Color(0xFFFFFFFF);

  /// A soft color for dividers that complements the background.
  Color get changelogDivider => const Color(0xFFDEDCD7);
}
