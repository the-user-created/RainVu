import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rainvu/features/data_tools/application/data_tools_provider.dart";
import "package:rainvu/features/data_tools/domain/data_tools_state.dart";
import "package:rainvu/l10n/app_localizations.dart";
import "package:rainvu/shared/widgets/dialogs/app_alert_dialog.dart";

class ExportProgressDialog extends ConsumerWidget {
  const ExportProgressDialog({super.key});

  String _getMessageForStage(
    final AppLocalizations l10n,
    final ExportStage stage,
  ) {
    switch (stage) {
      case ExportStage.none:
        return ""; // Should not be visible in this state
      case ExportStage.fetching:
        return l10n.exportProgressFetching;
      case ExportStage.formatting:
        return l10n.exportProgressFormatting;
      case ExportStage.saving:
        return l10n.exportProgressSaving;
    }
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final ExportStage stage = ref.watch(
      dataToolsProvider.select((final s) => s.exportStage),
    );
    final String message = _getMessageForStage(l10n, stage);

    return PopScope(
      canPop: false, // Prevent dismissing with back button
      child: AppAlertDialog(
        title: Text(l10n.exportProgressTitle),
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
              message,
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
