import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/data_tools/application/data_tools_provider.dart";
import "package:rain_wise/features/data_tools/presentation/widgets/export_data_card.dart";
import "package:rain_wise/features/data_tools/presentation/widgets/import_data_card.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_section_header.dart";

class DataToolsScreen extends ConsumerWidget {
  const DataToolsScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);

    ref.listen<String?>(
      dataToolsNotifierProvider.select((final s) => s.errorMessage),
      (final _, final errorMessage) {
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
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Export & Import"),
        centerTitle: false,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          children: const [
            SettingsSectionHeader(title: "EXPORT DATA"),
            ExportDataCard(),
            SizedBox(height: 24),
            SettingsSectionHeader(title: "IMPORT DATA"),
            ImportDataCard(),
          ],
        ),
      ),
    );
  }
}
