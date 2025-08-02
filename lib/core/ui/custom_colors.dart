import "package:flutter/material.dart";

/// Defines custom semantic color properties not available in the standard
/// [ColorScheme].
extension CustomColors on ColorScheme {
  /// A color for positive or successful states.
  /// Mapped from the legacy `success` color.
  Color get success => const Color(0xFF1B7F7A);
}
