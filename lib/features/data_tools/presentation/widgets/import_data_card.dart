import "dart:io";

import "package:dotted_border/dotted_border.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/data_tools/application/data_tools_provider.dart";
import "package:rain_wise/features/data_tools/domain/data_tools_state.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_card.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";

class ImportDataCard extends ConsumerWidget {
  const ImportDataCard({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    final DataToolsState state = ref.watch(dataToolsNotifierProvider);
    final DataToolsNotifier notifier =
        ref.read(dataToolsNotifierProvider.notifier);

    return SettingsCard(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Import Your Data",
                textAlign: TextAlign.center,
                style: theme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                "Import your previously exported rainfall data",
                textAlign: TextAlign.center,
                style: theme.bodyMedium.copyWith(color: theme.secondaryText),
              ),
              const SizedBox(height: 24),
              if (state.fileToImport == null)
                _FilePickerBox(onTap: notifier.pickFileForImport)
              else
                _FilePreview(
                  file: state.fileToImport!,
                  onClear: notifier.clearImportFile,
                ),
              const SizedBox(height: 24),
              AppButton(
                onPressed: (state.isImporting || state.fileToImport == null)
                    ? null
                    : notifier.importData,
                label: "Import Data",
                isLoading: state.isImporting,
                isExpanded: true,
                icon: Icon(
                  Icons.cloud_upload,
                  color: theme.secondaryBackground,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FilePickerBox extends StatelessWidget {
  const _FilePickerBox({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    return InkWell(
      onTap: onTap,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          color: theme.primaryText,
          dashPattern: const [6, 4],
          radius: const Radius.circular(12),
        ),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: theme.alternate,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.upload_file, color: theme.primaryText, size: 32),
                const SizedBox(height: 8),
                Text("Select File to Import", style: theme.bodyMedium),
                const SizedBox(height: 4),
                Text(
                  "CSV or JSON files only",
                  style: theme.bodySmall.copyWith(color: theme.secondaryText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FilePreview extends StatelessWidget {
  const _FilePreview({required this.file, required this.onClear});

  final File file;
  final VoidCallback onClear;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    // Get file name from path
    final String fileName = file.path.split("/").last;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.alternate,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.description_outlined, color: theme.primaryText),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              fileName,
              style: theme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: theme.secondaryText),
            onPressed: onClear,
            tooltip: "Clear selection",
          ),
        ],
      ),
    );
  }
}
