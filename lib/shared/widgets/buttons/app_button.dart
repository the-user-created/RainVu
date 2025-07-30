import "package:flutter/material.dart";

/// Defines the visual style of the [AppButton].
enum AppButtonStyle {
  /// Filled, for primary actions (e.g., Save, Submit).
  primary,

  /// Filled, for secondary actions (e.g., Add New, Send Feedback).
  secondary,

  /// Filled, for destructive actions (e.g., Delete).
  destructive,

  /// Outlined, for neutral secondary actions (e.g., Cancel).
  outline,

  /// Outlined, for destructive secondary actions (e.g., Cancel Subscription).
  outlineDestructive,
}

/// Defines the size of the button, affecting padding and minimum height.
enum AppButtonSize {
  regular,
  small,
}

/// A custom, reusable button widget for the application.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.onPressed,
    required this.label,
    super.key,
    this.style = AppButtonStyle.primary,
    this.size = AppButtonSize.regular,
    this.isLoading = false,
    this.isExpanded = false,
    this.icon,
    this.borderRadius,
  });

  /// The callback that is called when the button is tapped.
  final VoidCallback? onPressed;

  /// The text to display inside the button.
  final String label;

  /// The visual style of the button.
  final AppButtonStyle style;

  /// The size of the button.
  final AppButtonSize size;

  /// Whether to show a loading indicator.
  final bool isLoading;

  /// Whether the button should expand to fill its parent's width.
  final bool isExpanded;

  /// An optional icon to display before the label.
  final Widget? icon;

  /// An optional override for the button's border radius.
  final BorderRadius? borderRadius;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isDisabled = onPressed == null || isLoading;
    final bool isOutline = style == AppButtonStyle.outline ||
        style == AppButtonStyle.outlineDestructive;

    final Widget buttonChild = isLoading
        ? SizedBox.square(
            dimension: size == AppButtonSize.small ? 18 : 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOutline ? colorScheme.onSurface : colorScheme.onPrimary,
              ),
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

    final ButtonStyle buttonStyle = _getButtonStyle(context);

    final Widget button = isOutline
        ? OutlinedButton(
            onPressed: isDisabled ? null : onPressed,
            style: buttonStyle,
            child: buttonChild,
          )
        : ElevatedButton(
            onPressed: isDisabled ? null : onPressed,
            style: buttonStyle,
            child: buttonChild,
          );

    if (isExpanded) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  ButtonStyle _getButtonStyle(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final EdgeInsets padding;
    final Size minimumSize;

    switch (size) {
      case AppButtonSize.regular:
        padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
        minimumSize = const Size(88, 50);
      case AppButtonSize.small:
        padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
        minimumSize = const Size(64, 36);
    }

    switch (style) {
      case AppButtonStyle.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 2,
          padding: padding,
          minimumSize: minimumSize,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(25),
          ),
        );
      case AppButtonStyle.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: colorScheme.secondary,
          foregroundColor: colorScheme.onSecondary,
          elevation: 2,
          padding: padding,
          minimumSize: minimumSize,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(25),
          ),
        );
      case AppButtonStyle.destructive:
        return ElevatedButton.styleFrom(
          backgroundColor: colorScheme.error,
          foregroundColor: colorScheme.onError,
          elevation: 2,
          padding: padding,
          minimumSize: minimumSize,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(25),
          ),
        );
      case AppButtonStyle.outline:
        return OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          side: BorderSide(color: colorScheme.outline),
          elevation: 0,
          padding: padding,
          minimumSize: minimumSize,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          ),
        );
      case AppButtonStyle.outlineDestructive:
        return OutlinedButton.styleFrom(
          foregroundColor: colorScheme.error,
          side: BorderSide(color: colorScheme.error),
          elevation: 0,
          padding: padding,
          minimumSize: minimumSize,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(25),
          ),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (final states) => states.contains(WidgetState.hovered)
                ? colorScheme.error.withValues(alpha: 0.1)
                : null,
          ),
        );
    }
  }
}
