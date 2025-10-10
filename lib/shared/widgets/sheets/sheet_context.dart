import "package:flutter/material.dart";

/// An InheritedWidget that provides context about how a sheet is being presented.
///
/// This allows child widgets, like [InteractiveSheet], to adapt their appearance
/// based on whether they are displayed as a modal bottom sheet or a dialog.
class SheetContext extends InheritedWidget {
  const SheetContext({required super.child, required this.isDialog, super.key});

  /// True if the sheet is presented as a dialog, false otherwise.
  final bool isDialog;

  /// Retrieves the closest [SheetContext] instance from the widget tree.
  static SheetContext? of(final BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SheetContext>();

  @override
  bool updateShouldNotify(final SheetContext oldWidget) =>
      isDialog != oldWidget.isDialog;
}
