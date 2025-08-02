import "dart:io";

import "package:flutter/material.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "data_tools_state.freezed.dart";

/// The format for exporting data.
enum ExportFormat {
  csv,
  pdf,
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

    /// A flag indicating if an export operation is in progress.
    @Default(false) final bool isExporting,

    /// A flag indicating if an import operation is in progress.
    @Default(false) final bool isImporting,

    /// An error message, if any operation failed.
    final String? errorMessage,
  }) = _DataToolsState;
}
