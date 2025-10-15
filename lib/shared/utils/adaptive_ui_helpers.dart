import "package:flutter/material.dart";
import "package:rainvu/shared/widgets/sheets/sheet_context.dart";

/// Shows a modal UI that is a bottom sheet in portrait mode and a
/// dialog in landscape mode. This provides a better user experience on
/// wide screens where a full-width bottom sheet would be cramped.
///
/// It uses a [SheetContext] to inform child widgets about the presentation
/// style, allowing them to adapt their UI accordingly.
Future<T?> showAdaptiveSheet<T>({
  required final BuildContext context,
  required final WidgetBuilder builder,
  final bool isScrollControlled = true,
  final Color? backgroundColor,
}) {
  final Orientation orientation = MediaQuery.of(context).orientation;

  if (orientation == Orientation.landscape) {
    return showDialog<T>(
      context: context,
      builder: (final dialogContext) => SheetContext(
        isDialog: true,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 16,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: builder(dialogContext),
          ),
        ),
      ),
    );
  } else {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor ?? Colors.transparent,
      builder: (final sheetContext) => SheetContext(
        isDialog: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.8,
          ),
          child: builder(sheetContext),
        ),
      ),
    );
  }
}
