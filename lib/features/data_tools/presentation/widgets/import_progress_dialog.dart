import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/l10n/app_localizations.dart";

class ImportProgressDialog extends ConsumerWidget {
  const ImportProgressDialog({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    return PopScope(
      canPop: false, // Prevent dismissing with back button
      child: AlertDialog(
        title: Text(l10n.importProgressTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            const SizedBox.square(
              dimension: 60,
              child: CircularProgressIndicator(strokeWidth: 5),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.importProgressMessage,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
