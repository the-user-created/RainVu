import "dart:convert";
import "dart:io";
import "dart:math";

import "package:csv/csv.dart";
import "package:drift/drift.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:rain_wise/core/data/local/app_database.dart";
import "package:rain_wise/core/data/local/daos/rain_gauges_dao.dart";
import "package:rain_wise/core/data/local/daos/rainfall_entries_dao.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/data_tools/domain/data_tools_state.dart";
import "package:rain_wise/shared/domain/rain_gauge.dart" as domain_gauge;
import "package:rain_wise/shared/domain/rainfall_entry.dart" as domain_entry;
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:uuid/uuid.dart";

part "data_tools_repository.g.dart";

// TODO: put the data import/export logic onto a background isolate or use a loading indicator for large datasets

abstract class DataToolsRepository {
  Future<String?> exportData({
    required final ExportFormat format,
    final DateTimeRange? dateRange,
  });

  Future<void> importData(final File file);

  Future<ImportPreview> analyzeImportFile(final File file);

  Future<File?> pickFile();
}

@riverpod
DataToolsRepository dataToolsRepository(final Ref ref) {
  final AppDatabase db = ref.watch(appDatabaseProvider);
  return DriftDataToolsRepository(db.rainfallEntriesDao, db.rainGaugesDao, db);
}

// Helper class to hold parsed data
class _ParsedData {
  _ParsedData(this.gauges, this.entries);

  final List<domain_gauge.RainGauge> gauges;
  final List<domain_entry.RainfallEntry> entries;
}

class DriftDataToolsRepository implements DataToolsRepository {
  DriftDataToolsRepository(this._entriesDao, this._gaugesDao, this._db);

  final RainfallEntriesDao _entriesDao;
  final RainGaugesDao _gaugesDao;
  final AppDatabase _db;

  @override
  Future<String?> exportData({
    required final ExportFormat format,
    final DateTimeRange? dateRange,
  }) async {
    final List<RainfallEntryWithGauge> entriesWithGauges = dateRange != null
        ? await _entriesDao.getEntriesWithGaugesInRange(
            dateRange.start,
            dateRange.end,
          )
        : await _entriesDao.getAllEntriesWithGauges();

    if (entriesWithGauges.isEmpty) {
      throw Exception("No data available to export in the selected range.");
    }

    final String fileContent;
    final String extension;

    switch (format) {
      case ExportFormat.json:
        fileContent = _formatAsJson(entriesWithGauges);
        extension = "json";
      case ExportFormat.csv:
        fileContent = _formatAsCsv(entriesWithGauges);
        extension = "csv";
    }

    final String fileName =
        "rainwise_export_${DateTime.now().millisecondsSinceEpoch}.$extension";

    // Encode the file content to bytes
    final Uint8List fileBytes = utf8.encode(fileContent);

    // Use saveFile to open a system dialog for the user to choose location
    final String? resultPath = await FilePicker.platform.saveFile(
      dialogTitle: "Please select an output file:",
      fileName: fileName,
      bytes: fileBytes,
    );

    return resultPath;
  }

  @override
  Future<ImportPreview> analyzeImportFile(final File file) async {
    final _ParsedData parsedData = await _parseFile(file);

    // --- Gauge Analysis ---
    final List<RainGauge> existingGauges = await _gaugesDao.getAllGauges();
    final Map<String, RainGauge> existingGaugesByName = {
      for (final g in existingGauges) g.name.toLowerCase(): g,
    };

    final List<String> newGaugeNames = [];
    final Map<String, String> resolvedGaugeIdMap = {};

    for (final domain_gauge.RainGauge parsedGauge in parsedData.gauges) {
      final RainGauge? existingGauge =
          existingGaugesByName[parsedGauge.name.toLowerCase()];
      if (existingGauge == null) {
        newGaugeNames.add(parsedGauge.name);
        resolvedGaugeIdMap[parsedGauge.id] = parsedGauge.id;
      } else {
        resolvedGaugeIdMap[parsedGauge.id] = existingGauge.id;
      }
    }

    // --- Entry Analysis ---
    final List<RainfallEntry> existingDbEntries = await _entriesDao
        .getAllEntries();
    final Map<String, RainfallEntry> existingEntriesById = {
      for (final e in existingDbEntries) e.id: e,
    };

    int newEntriesCount = 0;
    int updatedEntriesCount = 0;
    int duplicateEntriesCount = 0;

    for (final domain_entry.RainfallEntry parsedEntry in parsedData.entries) {
      if (parsedEntry.id == null ||
          !existingEntriesById.containsKey(parsedEntry.id)) {
        newEntriesCount++;
        continue;
      }

      final RainfallEntry existingEntry = existingEntriesById[parsedEntry.id!]!;
      final String? resolvedGaugeId = resolvedGaugeIdMap[parsedEntry.gaugeId];

      final bool amountChanged =
          (existingEntry.amount - parsedEntry.amount).abs() > 0.001;
      final bool dateChanged = !existingEntry.date.isAtSameMomentAs(
        parsedEntry.date,
      );
      final bool gaugeChanged =
          (existingEntry.gaugeId ?? "") != (resolvedGaugeId ?? "");

      if (amountChanged || dateChanged || gaugeChanged) {
        updatedEntriesCount++;
      } else {
        duplicateEntriesCount++;
      }
    }

    return ImportPreview(
      newEntriesCount: newEntriesCount,
      updatedEntriesCount: updatedEntriesCount,
      newGaugesCount: newGaugeNames.length,
      newGaugeNames: newGaugeNames,
      duplicateEntriesCount: duplicateEntriesCount,
    );
  }

  @override
  Future<void> importData(final File file) async {
    final _ParsedData parsedData = await _parseFile(file);
    await _persistImportedData(parsedData.gauges, parsedData.entries);
  }

  @override
  Future<File?> pickFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["csv", "json"],
    );

    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  String _formatAsJson(final List<RainfallEntryWithGauge> data) {
    final List<domain_entry.RainfallEntry> entries = [];
    final List<domain_gauge.RainGauge> gauges = [];

    for (final item in data) {
      entries.add(
        domain_entry.RainfallEntry(
          id: item.entry.id,
          amount: item.entry.amount,
          date: item.entry.date,
          gaugeId: item.entry.gaugeId ?? "",
          unit: item.entry.unit,
        ),
      );
      if (item.gauge != null &&
          !gauges.any((final g) => g.id == item.gauge!.id)) {
        gauges.add(
          domain_gauge.RainGauge(id: item.gauge!.id, name: item.gauge!.name),
        );
      }
    }
    final Map<String, List<Map<String, dynamic>>> map = {
      "gauges": gauges.map((final g) => g.toJson()).toList(),
      "entries": entries.map((final e) => e.toJson()).toList(),
    };
    return const JsonEncoder.withIndent("  ").convert(map);
  }

  String _formatAsCsv(final List<RainfallEntryWithGauge> data) {
    final List<List<dynamic>> rows = [
      ["entry_id", "date", "amount", "unit", "gauge_id", "gauge_name"],
    ];

    for (final item in data) {
      rows.add([
        item.entry.id,
        item.entry.date.toIso8601String(),
        item.entry.amount,
        item.entry.unit,
        item.gauge?.id ?? "",
        item.gauge?.name ?? "",
      ]);
    }
    return const ListToCsvConverter().convert(rows);
  }

  Future<_ParsedData> _parseFile(final File file) async {
    final String content = await file.readAsString();
    final String extension = file.path.split(".").last.toLowerCase();

    if (extension == "json") {
      return _parseJsonContent(content);
    } else if (extension == "csv") {
      return _parseCsvContent(content);
    } else {
      throw Exception("Unsupported file format: $extension");
    }
  }

  _ParsedData _parseJsonContent(final String content) {
    final Map<String, dynamic> data = json.decode(content);
    final List<dynamic> gaugesJson = data["gauges"] ?? [];
    final List<dynamic> entriesJson = data["entries"] ?? [];

    final List<domain_gauge.RainGauge> gauges = gaugesJson
        .map((final g) => domain_gauge.RainGauge.fromJson(g))
        .toList();
    final List<domain_entry.RainfallEntry> entries = entriesJson
        .map((final e) => domain_entry.RainfallEntry.fromJson(e))
        .toList();

    return _ParsedData(gauges, entries);
  }

  _ParsedData _parseCsvContent(final String content) {
    final List<List<dynamic>> rows = const CsvToListConverter().convert(
      content,
      eol: "\n",
    );
    if (rows.length < 2) {
      return _ParsedData([], []);
    }

    final List<String> headers = rows.first
        .map((final e) => e.toString().trim())
        .toList();
    final int entryIdIndex = headers.indexOf("entry_id");
    final int gaugeNameIndex = headers.indexOf("gauge_name");
    final int dateIndex = headers.indexOf("date");
    final int amountIndex = headers.indexOf("amount");
    final int unitIndex = headers.indexOf("unit");

    final List<domain_gauge.RainGauge> gauges = [];
    final List<domain_entry.RainfallEntry> entries = [];
    final Map<String, domain_gauge.RainGauge> gaugeCache = {};

    for (int i = 1; i < rows.length; i++) {
      final List<dynamic> row = rows[i];
      if (row.length <=
          [gaugeNameIndex, dateIndex, amountIndex, unitIndex].reduce(max)) {
        continue;
      }

      final String? entryId;
      if (entryIdIndex != -1 && row.length > entryIdIndex) {
        final String idValue = row[entryIdIndex].toString();
        entryId = idValue.isNotEmpty ? idValue : null;
      } else {
        entryId = null;
      }

      final String gaugeName = row[gaugeNameIndex].toString().trim();

      domain_gauge.RainGauge? gauge = gaugeCache[gaugeName];
      if (gauge == null && gaugeName.isNotEmpty) {
        gauge = domain_gauge.RainGauge(id: const Uuid().v4(), name: gaugeName);
        gauges.add(gauge);
        gaugeCache[gaugeName] = gauge;
      }

      final String unitFromFile = row[unitIndex];
      double amountFromFile = double.parse(row[amountIndex].toString());

      if (unitFromFile.toLowerCase() == "in") {
        amountFromFile = amountFromFile.toMillimeters();
      }

      entries.add(
        domain_entry.RainfallEntry(
          id: entryId,
          amount: amountFromFile,
          date: DateTime.parse(row[dateIndex]),
          // Always save as mm
          unit: "mm",
          gaugeId: gauge?.id ?? "",
        ),
      );
    }
    return _ParsedData(gauges, entries);
  }

  Future<void> _persistImportedData(
    final List<domain_gauge.RainGauge> gauges,
    final List<domain_entry.RainfallEntry> entries,
  ) async {
    await _db.transaction(() async {
      final List<RainGauge> existingGauges = await _gaugesDao.getAllGauges();
      final Map<String, RainGauge> existingGaugesByName = {
        for (final g in existingGauges) g.name.toLowerCase(): g,
      };

      final List<RainGaugesCompanion> gaugesToInsert = [];
      final Map<String, String> resolvedGaugeIdMap = {};

      for (final parsedGauge in gauges) {
        final RainGauge? existingGauge =
            existingGaugesByName[parsedGauge.name.toLowerCase()];
        if (existingGauge == null) {
          gaugesToInsert.add(
            RainGaugesCompanion.insert(
              id: Value(parsedGauge.id),
              name: parsedGauge.name,
            ),
          );
          resolvedGaugeIdMap[parsedGauge.id] = parsedGauge.id;
        } else {
          resolvedGaugeIdMap[parsedGauge.id] = existingGauge.id;
        }
      }

      if (gaugesToInsert.isNotEmpty) {
        await _gaugesDao.insertGauges(gaugesToInsert);
      }

      final List<RainfallEntriesCompanion> entriesToUpsert = entries.map((
        final entry,
      ) {
        final String? finalGaugeId = resolvedGaugeIdMap[entry.gaugeId];

        double amountInMm = entry.amount;
        if (entry.unit.toLowerCase() == "in") {
          amountInMm = entry.amount.toMillimeters();
        }

        return RainfallEntriesCompanion.insert(
          id: entry.id == null ? const Value.absent() : Value(entry.id!),
          amount: amountInMm,
          date: entry.date,
          // Always save as mm
          unit: "mm",
          gaugeId: Value(finalGaugeId),
        );
      }).toList();

      if (entriesToUpsert.isNotEmpty) {
        await _entriesDao.upsertEntries(entriesToUpsert);
      }
    });
  }
}
