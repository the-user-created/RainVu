import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";

/// A styled, scrollable dialog that provides a consistent look and feel for alerts
/// across the app, based on [AlertDialog].
///
/// It standardizes the shape and styling, adds a subtle fade-in animation,
/// and automatically makes the content area scrollable to accommodate
/// accessibility settings like large text sizes.
class AppAlertDialog extends StatelessWidget {
  const AppAlertDialog({
    required this.title,
    required this.content,
    super.key,
    this.actions,
  });

  /// The title of the dialog, typically a [Text] widget.
  final Widget title;

  /// The main content of the dialog.
  final Widget content;

  /// The actions to display at the bottom of the dialog.
  final List<Widget>? actions;

  @override
  Widget build(final BuildContext context) => AlertDialog(
    scrollable: true,
    titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
    title: Animate(
      effects: const [FadeEffect(duration: Duration(milliseconds: 300))],
      child: title,
    ),
    contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
    content: Animate(
      effects: const [
        FadeEffect(
          duration: Duration(milliseconds: 300),
          delay: Duration(milliseconds: 50),
        ),
      ],
      child: content,
    ),
    actions: actions,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
  );
}
