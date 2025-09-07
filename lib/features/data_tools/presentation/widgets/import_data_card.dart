import "package:dotted_border/dotted_border.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/data_tools/application/data_tools_provider.dart";
import "package:rain_wise/features/data_tools/domain/data_tools_state.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_card.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";

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
                _FilePickerBox(onTap: () => notifier.pickFileForImport(l10n))
              else if (state.isParsing)
                const _ParsingPreview()
              else if (state.importPreview != null)
                _ImportPreviewSummary(
                  preview: state.importPreview!,
                  onConfirm: () => notifier.importData(l10n),
                  onCancel: notifier.clearImportFile,
                  isLoading: state.isImporting,
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

class _ParsingPreview extends StatelessWidget {
  const _ParsingPreview();

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: AppLoader(),
      ),
    );
  }
}

class _ImportPreviewSummary extends StatelessWidget {
  const _ImportPreviewSummary({
    required this.preview,
    required this.onConfirm,
    required this.onCancel,
    required this.isLoading,
  });

  final ImportPreview preview;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final bool isLoading;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.importPreviewTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.importPreviewSummary(
              preview.newEntriesCount,
              preview.newGaugesCount,
            ),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          if (preview.newGaugeNames.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              l10n.importPreviewNewGaugesListTitle,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: preview.newGaugeNames
                  .map(
                    (final name) => Chip(
                      label: Text(name),
                      backgroundColor: theme.colorScheme.secondaryContainer,
                      labelStyle: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  onPressed: onCancel,
                  label: l10n.importPreviewCancelButton,
                  style: AppButtonStyle.outline,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppButton(
                  onPressed: onConfirm,
                  label: l10n.importPreviewConfirmButton,
                  isLoading: isLoading,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
