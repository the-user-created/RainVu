import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";

/// A wrapper around [IconButton] to establish a consistent pattern for icon
/// buttons across the app, with a responsive press-and-hold animation.
class AppIconButton extends StatefulWidget {
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
  State<AppIconButton> createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton> {
  bool _isPressed = false;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // Start with the theme's defined style, or an empty one, and extend it.
    final ButtonStyle? buttonStyle = widget.backgroundColor != null
        ? (theme.iconButtonTheme.style ?? const ButtonStyle()).copyWith(
            backgroundColor: WidgetStateProperty.all(widget.backgroundColor),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
              ),
            ),
            minimumSize: const WidgetStatePropertyAll(Size(44, 44)),
            tapTargetSize: MaterialTapTargetSize.padded,
          )
        : null;

    return Listener(
          onPointerDown: (final _) => setState(() => _isPressed = true),
          onPointerUp: (final _) => setState(() => _isPressed = false),
          onPointerCancel: (final _) => setState(() => _isPressed = false),
          child: IconButton(
            icon: widget.icon,
            onPressed: widget.onPressed,
            tooltip: widget.tooltip,
            color: widget.color,
            iconSize: widget.iconSize,
            padding: widget.padding,
            splashRadius: (widget.iconSize ?? 24) + 16,
            style: buttonStyle,
          ),
        )
        .animate(target: _isPressed ? 1 : 0)
        .scaleXY(end: 0.85, duration: 150.ms, curve: Curves.easeOut);
  }
}
