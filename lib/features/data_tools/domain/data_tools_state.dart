import "dart:io";

import "package:flutter/material.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "data_tools_state.freezed.dart";

/// A summary of the data to be imported.
@freezed
abstract class ImportPreview with _$ImportPreview {
  const factory ImportPreview({
    required final int newEntriesCount,
    required final int newGaugesCount,
    required final List<String> newGaugeNames,
  }) = _ImportPreview;
}

/// The format for exporting data.
enum ExportFormat {
  csv,
  json,
}

/// The state for the data tools feature.
@freezed
abstract class DataToolsState with _$DataToolsState {
  const factory DataToolsState({
    /// The selected date range for export. Null means all time.
    final DateTimeRange? dateRange,

    /// The selected format for export.
    @Default(ExportFormat.csv) final ExportFormat exportFormat,

    /// The file selected for import.
    final File? fileToImport,

    /// The results of the import file analysis.
    final ImportPreview? importPreview,

    /// A flag indicating if an export operation is in progress.
    @Default(false) final bool isExporting,

    /// A flag indicating if an import operation is in progress.
    @Default(false) final bool isImporting,

    /// A flag indicating if an import file is being parsed.
    @Default(false) final bool isParsing,

    /// An error message, if any operation failed.
    final String? errorMessage,

    /// A success message to show after a successful operation.
    final String? successMessage,
  }) = _DataToolsState;
}
