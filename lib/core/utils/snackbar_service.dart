import "package:flutter/material.dart";
import "package:rainly/core/ui/custom_colors.dart";

/// Global key to access the top-level ScaffoldMessengerState.
/// This is crucial for showing SnackBars on top of dialogs/modals.
final snackbarKey = GlobalKey<ScaffoldMessengerState>();

/// Enum to define the type of message to be displayed.
enum MessageType { info, success, error }

/// SnackbarService provides a way to show SnackBar messages in the app.
class SnackbarService {
  // Private constructor for singleton pattern
  SnackbarService._();

  // Singleton instance
  static final SnackbarService _instance = SnackbarService._();

  /// Returns the singleton instance of SnackbarService
  static SnackbarService get instance => _instance;

  // Helper to get styling based on message type
  ({Color backgroundColor, IconData iconData}) _getStyleForType(
    final MessageType type,
    final ThemeData theme,
  ) {
    switch (type) {
      case MessageType.success:
        return (
          backgroundColor: theme.colorScheme.success,
          iconData: Icons.check_circle_outline,
        );
      case MessageType.error:
        return (
          backgroundColor: theme.colorScheme.error,
          iconData: Icons.error_outline,
        );
      case MessageType.info:
        return (
          backgroundColor: theme.colorScheme.inverseSurface,
          iconData: Icons.info_outline,
        );
    }
  }

  /// Shows a styled, responsive, and theme-aware SnackBar.
  ///
  /// - [message]: The text to display.
  /// - [type]: The message type (info, success, error), which determines the
  ///           default color and icon.
  /// - [duration]: How long the SnackBar is visible.
  /// - [backgroundColor], [textStyle], [icon], [margin]: Optional overrides
  ///   for custom styling.
  void showSnackBar(
    final String message, {
    final MessageType type = MessageType.info,
    final Duration duration = const Duration(seconds: 4),
    final Color? backgroundColor,
    final TextStyle? textStyle,
    final EdgeInsets? margin,
    final IconData? icon,
  }) {
    final BuildContext? context = snackbarKey.currentContext;
    final ScaffoldMessengerState? messengerState = snackbarKey.currentState;

    if (context == null || messengerState == null) {
      debugPrint(
        "SnackbarService: Cannot show SnackBar. No context or state available.",
      );
      return;
    }

    messengerState.hideCurrentSnackBar();

    final ThemeData theme = Theme.of(context);
    final double screenWidth = MediaQuery.of(context).size.width;

    // Determine styling based on type and provided overrides
    final ({Color backgroundColor, IconData iconData}) typeStyle =
        _getStyleForType(type, theme);
    final Color finalBgColor = backgroundColor ?? typeStyle.backgroundColor;
    final IconData finalIconData = icon ?? typeStyle.iconData;

    // Intelligently select text color for contrast if not explicitly provided.
    final Brightness bgBrightness = ThemeData.estimateBrightnessForColor(
      finalBgColor,
    );
    final Color defaultTextColor = bgBrightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    final TextStyle finalTextStyle =
        textStyle ?? TextStyle(color: defaultTextColor);

    // Use responsive margin by default, but allow it to be overridden.
    final EdgeInsets finalMargin =
        margin ??
        EdgeInsets.symmetric(
          horizontal: screenWidth > 600 ? (screenWidth - 550) / 2 : 16.0,
          vertical: 20,
        );

    messengerState.showSnackBar(
      SnackBar(
        duration: duration,
        backgroundColor: finalBgColor,
        behavior: SnackBarBehavior.floating,
        margin: finalMargin,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        content: Row(
          children: [
            Icon(finalIconData, color: finalTextStyle.color, size: 22),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: finalTextStyle)),
          ],
        ),
      ),
    );
  }
}
