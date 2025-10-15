import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rainvu/core/utils/snackbar_service.dart";
import "package:rainvu/features/data_tools/application/data_tools_provider.dart";
import "package:rainvu/features/data_tools/presentation/widgets/export_data_card.dart";
import "package:rainvu/features/data_tools/presentation/widgets/export_progress_dialog.dart";
import "package:rainvu/features/data_tools/presentation/widgets/import_data_card.dart";
import "package:rainvu/features/data_tools/presentation/widgets/import_progress_dialog.dart";
import "package:rainvu/features/settings/presentation/widgets/settings_section_header.dart";
import "package:rainvu/l10n/app_localizations.dart";
import "package:rainvu/shared/utils/ui_helpers.dart";

class DataToolsScreen extends ConsumerWidget {
  const DataToolsScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    ref
      ..listen<String?>(dataToolsProvider.select((final s) => s.errorMessage), (
        final _,
        final errorMessage,
      ) {
        if (errorMessage != null) {
          showSnackbar(errorMessage, type: MessageType.error);
        }
      })
      ..listen<String?>(
        dataToolsProvider.select((final s) => s.successMessage),
        (final _, final successMessage) {
          if (successMessage != null) {
            showSnackbar(successMessage, type: MessageType.success);
          }
        },
      )
      ..listen<bool>(dataToolsProvider.select((final s) => s.isImporting), (
        final wasImporting,
        final isImporting,
      ) {
        if (isImporting) {
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (final _) => const ImportProgressDialog(),
          );
        } else if (wasImporting == true && !isImporting) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      })
      ..listen<bool>(dataToolsProvider.select((final s) => s.isExporting), (
        final wasExporting,
        final isExporting,
      ) {
        if (isExporting) {
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (final _) => const ExportProgressDialog(),
          );
        } else if (wasExporting == true && !isExporting) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dataToolsTitle, style: theme.textTheme.titleLarge),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 24),
            children: [
              SettingsSectionHeader(
                title: l10n.dataToolsExportDataSectionTitle,
              ),
              const ExportDataCard(),
              const SizedBox(height: 24),
              SettingsSectionHeader(
                title: l10n.dataToolsImportDataSectionTitle,
              ),
              const ImportDataCard(),
            ],
          ),
        ),
      ),
    );
  }
}
