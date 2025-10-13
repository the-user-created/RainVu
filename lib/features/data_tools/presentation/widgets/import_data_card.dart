import "package:dotted_border/dotted_border.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/data_tools/application/data_tools_provider.dart";
import "package:rain_wise/features/data_tools/domain/data_tools_state.dart";
import "package:rain_wise/features/settings/presentation/widgets/settings_card.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";
import "package:rain_wise/shared/widgets/placeholders.dart";
import "package:shimmer/shimmer.dart";

class ImportDataCard extends ConsumerWidget {
  const ImportDataCard({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final DataToolsState state = ref.watch(dataToolsProvider);
    final DataToolsNotifier notifier = ref.read(dataToolsProvider.notifier);

    return SettingsCard(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.importDataCardDescription,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
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
      borderRadius: BorderRadius.circular(12),
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          color: theme.colorScheme.onSurface,
          dashPattern: const [6, 4],
          radius: const Radius.circular(12),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.upload_file,
                  color: theme.colorScheme.onSurface,
                  size: 32,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.filePickerBoxTitle,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.filePickerBoxSubtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Shimmer.fromColors(
        baseColor: theme.colorScheme.surface,
        highlightColor: theme.colorScheme.surfaceContainerHighest,
        child: const Column(
          children: [
            LinePlaceholder(height: 16, width: 120),
            SizedBox(height: 16),
            LinePlaceholder(height: 12),
            SizedBox(height: 8),
            LinePlaceholder(height: 12),
            SizedBox(height: 8),
            LinePlaceholder(height: 12, width: 200),
          ],
        ),
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

    final List<String> summaries = [];
    if (preview.newEntriesCount > 0) {
      summaries.add(l10n.importPreviewSummaryEntries(preview.newEntriesCount));
    }
    if (preview.updatedEntriesCount > 0) {
      summaries.add(
        l10n.importPreviewSummaryUpdated(preview.updatedEntriesCount),
      );
    }
    if (preview.newGaugesCount > 0) {
      summaries.add(l10n.importPreviewSummaryGauges(preview.newGaugesCount));
    }

    final String summaryText = summaries.isNotEmpty
        ? summaries.join(". ")
        : l10n.importPreviewSummaryNoChanges;

    final bool hasChanges =
        preview.newEntriesCount > 0 ||
        preview.updatedEntriesCount > 0 ||
        preview.newGaugesCount > 0;

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
            summaryText,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          if (preview.duplicateEntriesCount > 0) ...[
            const SizedBox(height: 8),
            Text(
              l10n.importPreviewDuplicatesSummary(
                preview.duplicateEntriesCount,
              ),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (preview.newGaugeNames.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              l10n.importPreviewNewGaugesListTitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: preview.newGaugeNames
                  .map(
                    (final name) => Chip(
                      label: Text(name, overflow: TextOverflow.ellipsis),
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
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 12,
            runSpacing: 12,
            children: [
              AppButton(
                onPressed: onCancel,
                label: l10n.importPreviewCancelButton,
                style: AppButtonStyle.destructive,
                size: AppButtonSize.small,
              ),
              AppButton(
                onPressed: hasChanges ? onConfirm : null,
                label: l10n.importPreviewConfirmButton,
                isLoading: isLoading,
                size: AppButtonSize.small,
                style: AppButtonStyle.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
