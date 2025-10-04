import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/data_tools/application/data_tools_provider.dart";
import "package:rain_wise/features/data_tools/presentation/widgets/export_data_card.dart";
import "package:rain_wise/features/data_tools/presentation/widgets/import_data_card.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_section_header.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/utils/ui_helpers.dart";

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
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: theme.colorScheme.error,
              ),
            );
        }
      })
      ..listen<String?>(
        dataToolsProvider.select((final s) => s.successMessage),
        (final _, final successMessage) {
          if (successMessage != null) {
            showSnackbar(context, successMessage);
          }
        },
      );

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
