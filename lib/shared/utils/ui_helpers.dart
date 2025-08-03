import "package:flutter/material.dart";

void showSnackbar(
  final BuildContext context,
  final String message, {
  final bool loading = false,
  final int duration = 4,
}) {
  final ThemeData theme = Theme.of(context);
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          if (loading)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 10),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  // Use a theme-aware color for the spinner
                  color: theme.colorScheme.onInverseSurface,
                ),
              ),
            ),
          Text(message),
        ],
      ),
      duration: Duration(seconds: duration),
    ),
  );
}
