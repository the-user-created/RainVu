import "dart:io";

import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/material.dart";
import "package:rainvu/core/firebase/analytics_service.dart";
import "package:rainvu/features/data_tools/data/data_tools_repository.dart";
import "package:rainvu/features/data_tools/domain/data_tools_exceptions.dart";
import "package:rainvu/features/data_tools/domain/data_tools_state.dart";
import "package:rainvu/l10n/app_localizations.dart";
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

  String _getErrorMessage(final Object e, final AppLocalizations l10n) =>
      switch (e) {
        final NoDataToExportException _ => l10n.exportErrorNoData,
        final UnsupportedFileFormatException e =>
          l10n.importErrorUnsupportedFormat(e.extension),
        final MissingCsvHeadersException e => l10n.importErrorMissingHeaders(
          e.headers.join(", "),
        ),
        final CsvRowColumnCountException e => l10n.importErrorColumnCount(
          e.rowNumber,
          e.expected,
          e.actual,
        ),
        final CsvMissingValueException e => l10n.importErrorMissingValue(
          e.columnName,
          e.rowNumber,
        ),
        final CsvRowFormatException e => l10n.importErrorInvalidData(
          e.rowNumber,
          e.details,
        ),
        final CsvRowProcessingException e => l10n.importErrorProcessingRow(
          e.rowNumber,
        ),
        final InvalidJsonFormatException _ => l10n.importErrorInvalidJson,
        final JsonMissingKeysException e => l10n.importErrorJsonMissingKeys(
          e.keys.join(", "),
        ),
        final JsonInvalidValueException e => l10n.importErrorJsonInvalidValue(
          e.details,
        ),
        _ => l10n.genericError,
      };

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
      } catch (e, s) {
        FirebaseCrashlytics.instance.recordError(
          e,
          s,
          reason: "File parsing for import preview failed",
        );
        state = state.copyWith(
          errorMessage: _getErrorMessage(e, l10n),
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
        // Log analytics event on success
        await ref
            .read(analyticsServiceProvider)
            .exportData(
              format: state.exportFormat.name,
              range: state.dateRange == null ? "all_time" : "custom",
            );
      }
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Export data action failed",
      );
      state = state.copyWith(errorMessage: _getErrorMessage(e, l10n));
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

      // Log analytics event on success
      final String fileExtension = state.fileToImport!.path
          .split(".")
          .last
          .toLowerCase();
      final ImportPreview preview = state.importPreview!;
      await ref
          .read(analyticsServiceProvider)
          .importData(
            format: fileExtension,
            newEntries: preview.newEntriesCount,
            updatedEntries: preview.updatedEntriesCount,
            newGauges: preview.newGaugesCount,
          );

      state = state.copyWith(
        fileToImport: null,
        importPreview: null, // Also clear preview on success
        successMessage: l10n.dataToolsImportSuccess,
      );
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Import data action failed",
      );
      state = state.copyWith(errorMessage: _getErrorMessage(e, l10n));
    } finally {
      state = state.copyWith(isImporting: false);
    }
  }
}
