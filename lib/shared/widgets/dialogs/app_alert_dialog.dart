import "package:flutter/material.dart";

/// A styled dialog that provides a consistent look and feel for alerts
/// across the app, based on [AlertDialog].
///
/// It standardizes the shape, title, and content styling.
class AppAlertDialog extends StatelessWidget {
  const AppAlertDialog({
    required this.title,
    required this.content,
    super.key,
    this.actions,
  });

  /// The title of the dialog.
  final String title;

  /// The main content of the dialog.
  final Widget content;

  /// The actions to display at the bottom of the dialog.
  final List<Widget>? actions;

  @override
  Widget build(final BuildContext context) => AlertDialog(
    title: Text(title),
    content: content,
    actions: actions,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
  );
}
