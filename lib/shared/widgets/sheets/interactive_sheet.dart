import "package:flutter/material.dart";

/// A reusable, styled bottom sheet container that provides a consistent
/// look and feel for modal sheets across the app.
///
/// It includes a drag handle, rounded corners, and standard padding.
/// The content of the sheet is passed via the [child] parameter.
/// The sheet's content is wrapped in a `SingleChildScrollView` to accommodate
/// content that may overflow, especially when the keyboard is visible.
class InteractiveSheet extends StatelessWidget {
  const InteractiveSheet({
    required this.child,
    this.title,
    this.titleAlign,
    this.actions,
    this.showDragHandle = true,
    super.key,
  });

  /// The main content of the bottom sheet.
  final Widget child;

  /// An optional title widget displayed at the top of the sheet.
  final Widget? title;

  /// The alignment of the title widget. Defaults to [TextAlign.center].
  final TextAlign? titleAlign;

  /// Optional action widgets (e.g., buttons) displayed at the bottom of the sheet.
  final List<Widget>? actions;

  /// Whether to show the top drag handle. Defaults to true.
  final bool showDragHandle;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final List<Widget> children = [
      if (showDragHandle)
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      if (title != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: DefaultTextStyle(
            style: theme.textTheme.headlineSmall!,
            textAlign: titleAlign ?? TextAlign.center,
            child: title!,
          ),
        ),
      Flexible(child: SingleChildScrollView(child: child)),
      if (actions != null && actions!.isNotEmpty) ...[
        const SizedBox(height: 24),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: actions!),
      ],
    ];

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
