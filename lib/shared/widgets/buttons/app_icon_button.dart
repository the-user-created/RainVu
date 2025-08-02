import "package:flutter/material.dart";

/// A wrapper around [IconButton] to establish a consistent pattern for icon
/// buttons across the app.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.tooltip,
    this.color,
    this.iconSize,
    this.padding = const EdgeInsets.all(8),
    this.backgroundColor,
    this.borderRadius,
  });

  /// The icon to display.
  final Widget icon;

  /// The callback that is called when the button is tapped.
  final VoidCallback? onPressed;

  /// Text that describes the action that will occur when the button is pressed.
  final String? tooltip;

  /// The color to use for the icon.
  final Color? color;

  /// The size of the icon.
  final double? iconSize;

  /// The padding around the icon.
  final EdgeInsetsGeometry padding;

  /// An optional background color for the button.
  final Color? backgroundColor;

  /// An optional border radius for the button's background.
  final BorderRadius? borderRadius;

  @override
  Widget build(final BuildContext context) {
    // The button style to apply.
    final ButtonStyle? buttonStyle = backgroundColor != null
        ? IconButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(8),
            ),
            minimumSize: const Size(44, 44), // Ensure consistent tap target
          )
        : null;

    return IconButton(
      icon: icon,
      onPressed: onPressed,
      tooltip: tooltip,
      color: color,
      iconSize: iconSize,
      padding: padding,
      splashRadius: (iconSize ?? 24) + 16,
      style: buttonStyle,
    );
  }
}
