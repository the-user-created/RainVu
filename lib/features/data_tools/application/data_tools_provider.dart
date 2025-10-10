import "dart:io";

import "package:flutter/material.dart";
import "package:rain_wise/features/data_tools/data/data_tools_repository.dart";
import "package:rain_wise/features/data_tools/domain/data_tools_state.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "data_tools_provider.g.dart";

@riverpod
class DataToolsNotifier extends _$DataToolsNotifier {
  @override
  DataToolsState build() => const DataToolsState();

  void setExportFormat(final ExportFormat format) {
    state = state.copyWith(exportFormat: format);
  }

  void setDateRange(final DateTimeRange? range) {
    state = state.copyWith(dateRange: range);
  }

  Future<void> pickFileForImport(final AppLocalizations l10n) async {
    // Clear previous messages and states
    state = state.copyWith(
      errorMessage: null,
      successMessage: null,
      importPreview: null,
    );

    final File? file = await ref.read(dataToolsRepositoryProvider).pickFile();
    if (file != null) {
      state = state.copyWith(fileToImport: file, isParsing: true);
      try {
        final ImportPreview preview = await ref
            .read(dataToolsRepositoryProvider)
            .analyzeImportFile(file);
        state = state.copyWith(importPreview: preview, isParsing: false);
      } catch (e) {
        state = state.copyWith(
          errorMessage: l10n.dataToolsParseFailed(e),
          isParsing: false,
          fileToImport: null,
          importPreview: null,
        );
      }
    }
  }

  void clearImportFile() {
    state = state.copyWith(fileToImport: null, importPreview: null);
  }

  Future<void> exportData(final AppLocalizations l10n) async {
    if (state.isExporting) {
      return;
    }
    state = state.copyWith(
      isExporting: true,
      errorMessage: null,
      successMessage: null,
      exportStage: ExportStage.none,
    );

    try {
      final String? path = await ref
          .read(dataToolsRepositoryProvider)
          .exportData(
            format: state.exportFormat,
            dateRange: state.dateRange,
            onProgress: (final stage) {
              state = state.copyWith(exportStage: stage);
            },
          );
      if (path != null) {
        state = state.copyWith(
          successMessage: l10n.dataToolsExportSuccess(path),
        );
      }
    } catch (e) {
      state = state.copyWith(errorMessage: l10n.dataToolsExportFailed(e));
    } finally {
      state = state.copyWith(isExporting: false, exportStage: ExportStage.none);
    }
  }

  Future<void> importData(final AppLocalizations l10n) async {
    if (state.isImporting ||
        state.fileToImport == null ||
        state.importPreview == null) {
      return;
    }
    state = state.copyWith(
      isImporting: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      await ref
          .read(dataToolsRepositoryProvider)
          .importData(state.fileToImport!);
      state = state.copyWith(
        fileToImport: null,
        importPreview: null, // Also clear preview on success
        successMessage: l10n.dataToolsImportSuccess,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: l10n.dataToolsImportFailed(e));
    } finally {
      state = state.copyWith(isImporting: false);
    }
  }
}
