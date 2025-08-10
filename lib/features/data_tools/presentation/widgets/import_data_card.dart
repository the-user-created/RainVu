import "dart:io";

import "package:dotted_border/dotted_border.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/data_tools/application/data_tools_provider.dart";
import "package:rain_wise/features/data_tools/domain/data_tools_state.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_card.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";
import "package:rain_wise/shared/widgets/buttons/app_icon_button.dart";

class ImportDataCard extends ConsumerWidget {
  const ImportDataCard({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
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
                l10n.importDataCardTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.importDataCardDescription,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
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
                    : () => notifier.importData(l10n),
                label: l10n.importDataButtonLabel,
                isLoading: state.isImporting,
                isExpanded: true,
                icon: const Icon(Icons.cloud_upload, size: 20),
                style: AppButtonStyle.secondary,
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
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: onTap,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          color: theme.colorScheme.onSurface,
          dashPattern: const [6, 4],
          radius: const Radius.circular(12),
        ),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.upload_file,
                  color: theme.colorScheme.onSurface,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.filePickerBoxTitle,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.filePickerBoxSubtitle,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
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
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    // Get file name from path
    final String fileName = file.path.split("/").last;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.description_outlined, color: theme.colorScheme.onSurface),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              fileName,
              style: theme.textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          AppIconButton(
            icon: Icon(Icons.close, color: theme.colorScheme.onSurfaceVariant),
            onPressed: onClear,
            tooltip: l10n.clearSelectionTooltip,
          ),
        ],
      ),
    );
  }
}
