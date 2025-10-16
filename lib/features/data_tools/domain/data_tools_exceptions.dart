/// Base class for all data tools related exceptions.
sealed class DataToolsException implements Exception {
  const DataToolsException([this.message]);

  final String? message;

  @override
  String toString() => message ?? "An unknown data tools error occurred.";
}

/// Thrown when an export is attempted but no data exists.
class NoDataToExportException extends DataToolsException {
  const NoDataToExportException();

  @override
  String toString() => "NoDataToExportException: No data available for export.";
}

/// Thrown when an import file has an unsupported extension.
class UnsupportedFileFormatException extends DataToolsException {
  const UnsupportedFileFormatException(this.extension);

  final String extension;

  @override
  String toString() =>
      "UnsupportedFileFormatException: The file extension '$extension' is not supported.";
}

/// Thrown when an imported CSV is missing required columns.
class MissingCsvHeadersException extends DataToolsException {
  const MissingCsvHeadersException(this.headers);

  final List<String> headers;

  @override
  String toString() =>
      "MissingCsvHeadersException: The CSV file is missing required columns: ${headers.join(", ")}.";
}

/// Thrown when a row in a CSV file has a different number of columns than the header.
class CsvRowColumnCountException extends DataToolsException {
  const CsvRowColumnCountException({
    required this.rowNumber,
    required this.expected,
    required this.actual,
  });

  final int rowNumber;
  final int expected;
  final int actual;

  @override
  String toString() =>
      "CsvRowColumnCountException: Row $rowNumber has $actual columns, but expected $expected.";
}

/// Thrown when data in a specific CSV row cannot be parsed correctly.
class CsvRowFormatException extends DataToolsException {
  const CsvRowFormatException({required this.rowNumber, required this.details});

  final int rowNumber;
  final String details;

  @override
  String toString() =>
      "CsvRowFormatException: Invalid data format in row $rowNumber. Details: $details";
}

/// A generic exception for when a CSV row cannot be processed.
class CsvRowProcessingException extends DataToolsException {
  const CsvRowProcessingException(this.rowNumber);

  final int rowNumber;

  @override
  String toString() =>
      "CsvRowProcessingException: Could not process row $rowNumber.";
}

class CsvMissingValueException extends DataToolsException {
  const CsvMissingValueException({
    required this.rowNumber,
    required this.columnName,
  });

  final int rowNumber;
  final String columnName;

  @override
  String toString() =>
      "CsvMissingValueException: Missing value for column '$columnName' in row $rowNumber.";
}

/// Thrown when a file's content cannot be parsed as valid JSON.
class InvalidJsonFormatException extends DataToolsException {
  const InvalidJsonFormatException();

  @override
  String toString() =>
      "InvalidJsonFormatException: The file content is not valid JSON.";
}

/// Thrown when an imported JSON file is missing required top-level keys.
class JsonMissingKeysException extends DataToolsException {
  const JsonMissingKeysException(this.keys);

  final List<String> keys;

  @override
  String toString() =>
      "JsonMissingKeysException: The JSON file is missing required keys: ${keys.join(", ")}.";
}

/// Thrown when a value in the JSON file has an incorrect data type.
class JsonWrongTypeException extends DataToolsException {
  const JsonWrongTypeException({
    required this.path,
    required this.expected,
    required this.actual,
  });

  final String path;
  final String expected;
  final String actual;

  @override
  String toString() =>
      "JsonWrongTypeException: Invalid type at path '$path'. Expected $expected, but got $actual.";
}

/// Thrown when a required field is missing from a JSON object.
class JsonMissingFieldException extends DataToolsException {
  const JsonMissingFieldException({required this.path, required this.field});

  final String path;
  final String field;

  @override
  String toString() =>
      "JsonMissingFieldException: Missing required field '$field' at path '$path'.";
}

/// Thrown when a field in the JSON has an invalid format (e.g., a bad date string).
class JsonInvalidFormatException extends DataToolsException {
  const JsonInvalidFormatException({
    required this.path,
    required this.field,
    required this.expectedFormat,
  });

  final String path;
  final String field;
  final String expectedFormat;

  @override
  String toString() =>
      "JsonInvalidFormatException: Invalid format for field '$field' at path '$path'. Expected format: $expectedFormat.";
}
