import "package:flutter/material.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

/// Defines the visual style of the [AppButton].
enum AppButtonStyle {
  /// The primary style, for the most important actions.
  primary,

  /// A style for destructive actions like 'Delete'.
  destructive,

  /// An outlined style for secondary destructive actions.
  outlineDestructive,
}

/// A custom, reusable button widget for the application.
///
/// This button is built on top of Flutter's [ElevatedButton] and is designed
/// to be flexible and consistent with the app's design language.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.onPressed,
    required this.label,
    super.key,
    this.style = AppButtonStyle.primary,
    this.isLoading = false,
    this.isExpanded = false,
    this.icon,
  });

  /// The callback that is called when the button is tapped.
  /// If null, the button will be disabled.
  final VoidCallback? onPressed;

  /// The text to display inside the button.
  final String label;

  /// The visual style of the button. Defaults to [AppButtonStyle.primary].
  final AppButtonStyle style;

  /// Whether to show a loading indicator. If true, the button is disabled.
  final bool isLoading;

  /// Whether the button should expand to fill its parent's width.
  final bool isExpanded;

  /// An optional icon to display before the label.
  final Widget? icon;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    final bool isDisabled = onPressed == null || isLoading;

    final Widget buttonChild = isLoading
        ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    final ButtonStyle buttonStyle = _getButtonStyle(theme);

    final Widget button = ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: buttonStyle,
      child: buttonChild,
    );

    if (isExpanded) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }

  ButtonStyle _getButtonStyle(final FlutterFlowTheme theme) {
    switch (style) {
      case AppButtonStyle.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: theme.accent1,
          foregroundColor: Colors.white,
          disabledBackgroundColor: theme.accent1.withValues(alpha: 0.5),
          disabledForegroundColor: Colors.white.withValues(alpha: 0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          textStyle: theme.titleSmall.override(
            fontFamily: "Readex Pro",
            color: Colors.white,
          ),
          minimumSize: const Size(88, 50),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.2),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (final states) {
              if (states.contains(WidgetState.hovered)) {
                return theme.primary;
              }
              return null;
            },
          ),
        );
      case AppButtonStyle.destructive:
        return ElevatedButton.styleFrom(
          backgroundColor: theme.error,
          foregroundColor: Colors.white,
          disabledBackgroundColor: theme.error.withValues(alpha: 0.5),
          disabledForegroundColor: Colors.white.withValues(alpha: 0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          textStyle: theme.titleSmall.override(
            fontFamily: "Readex Pro",
            color: Colors.white,
          ),
          minimumSize: const Size(88, 50),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.2),
        );
      case AppButtonStyle.outlineDestructive:
        return OutlinedButton.styleFrom(
          foregroundColor: theme.error,
          backgroundColor: Colors.transparent,
          side: BorderSide(color: theme.error),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          textStyle: theme.titleSmall.override(
            fontFamily: "Readex Pro",
          ),
          minimumSize: const Size(88, 50),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          elevation: 0,
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (final states) {
              if (states.contains(WidgetState.hovered)) {
                return theme.error.withValues(alpha: 0.1);
              }
              return null;
            },
          ),
        );
    }
  }
}
