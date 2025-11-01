import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";

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
enum AppButtonSize { regular, small }

/// A custom, reusable button widget for the application with a responsive
/// press-and-hold animation.
class AppButton extends StatefulWidget {
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
    this.semanticLabel,
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

  /// An optional accessibility label to override the visual label for screen readers.
  final String? semanticLabel;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isPressed = false;

  ButtonStyle _getButtonStyle(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final EdgeInsets padding;
    final Size minimumSize;

    switch (widget.size) {
      case AppButtonSize.regular:
        padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
        minimumSize = const Size(88, 50);
      case AppButtonSize.small:
        padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
        minimumSize = const Size(64, 36);
    }

    final ButtonStyle sizeStyle = ButtonStyle(
      padding: WidgetStateProperty.all(padding),
      minimumSize: WidgetStateProperty.all(minimumSize),
      shape: widget.borderRadius != null
          ? WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: widget.borderRadius!),
            )
          : null,
    );

    switch (widget.style) {
      case AppButtonStyle.primary:
        return (theme.elevatedButtonTheme.style ?? const ButtonStyle()).merge(
          sizeStyle,
        );
      case AppButtonStyle.secondary:
        return (theme.elevatedButtonTheme.style ?? const ButtonStyle())
            .copyWith(
              backgroundColor: WidgetStateProperty.all(colorScheme.secondary),
              foregroundColor: WidgetStateProperty.all(colorScheme.onSecondary),
            )
            .merge(sizeStyle);
      case AppButtonStyle.destructive:
        return (theme.elevatedButtonTheme.style ?? const ButtonStyle())
            .copyWith(
              backgroundColor: WidgetStateProperty.all(colorScheme.error),
              foregroundColor: WidgetStateProperty.all(colorScheme.onError),
            )
            .merge(sizeStyle);
      case AppButtonStyle.outline:
        return (theme.outlinedButtonTheme.style ?? const ButtonStyle()).merge(
          sizeStyle,
        );
      case AppButtonStyle.outlineDestructive:
        return (theme.outlinedButtonTheme.style ?? const ButtonStyle())
            .copyWith(
              foregroundColor: WidgetStateProperty.all(colorScheme.error),
              side: WidgetStateProperty.all(
                BorderSide(color: colorScheme.error),
              ),
              overlayColor: WidgetStateProperty.resolveWith<Color?>(
                (final states) => states.contains(WidgetState.hovered)
                    ? colorScheme.error.withValues(alpha: 0.1)
                    : null,
              ),
            )
            .merge(sizeStyle);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final bool isDisabled = widget.onPressed == null || widget.isLoading;
    final bool isOutline =
        widget.style == AppButtonStyle.outline ||
        widget.style == AppButtonStyle.outlineDestructive;

    final ButtonStyle buttonStyle = _getButtonStyle(context);

    final Widget buttonChild = widget.isLoading
        ? SizedBox.square(
            dimension: widget.size == AppButtonSize.small ? 18 : 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color?>(
                buttonStyle.foregroundColor?.resolve({}),
              ),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                widget.icon!,
                const SizedBox(width: 8),
              ],
              Flexible(child: Text(widget.label, textAlign: TextAlign.center)),
            ],
          );

    Widget button = isOutline
        ? OutlinedButton(
            onPressed: isDisabled ? null : widget.onPressed,
            style: buttonStyle,
            child: buttonChild,
          )
        : ElevatedButton(
            onPressed: isDisabled ? null : widget.onPressed,
            style: buttonStyle,
            child: buttonChild,
          );

    if (widget.semanticLabel != null) {
      button = Semantics(
        label: widget.semanticLabel,
        button: true,
        enabled: !isDisabled,
        excludeSemantics: true,
        child: button,
      );
    }

    final Widget interactiveButton =
        Listener(
              onPointerDown: (final _) => setState(() => _isPressed = true),
              onPointerUp: (final _) => setState(() => _isPressed = false),
              onPointerCancel: (final _) => setState(() => _isPressed = false),
              child: button,
            )
            .animate(target: _isPressed ? 1 : 0)
            .scaleXY(end: 0.97, duration: 150.ms, curve: Curves.easeOut);

    if (widget.isExpanded) {
      return SizedBox(width: double.infinity, child: interactiveButton);
    }

    return interactiveButton;
  }
}
