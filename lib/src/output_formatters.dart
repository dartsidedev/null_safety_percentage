import 'dart:convert';
import 'migration_overview.dart';

abstract class OutputFormatter {
  static const ascii = AsciiOutputFormatter();
  static const human = HumanOutputFormatter();
  static const json = JsonOutputFormatter();

  String format({
    required MigrationOverview files,
    required MigrationOverview lines,
  });
}

/// This class formats the results so that it is easy to manipulate with
/// different Unix shell tools.
class AsciiOutputFormatter implements OutputFormatter {
  const AsciiOutputFormatter();

  @override
  String format({
    required files,
    required lines,
  }) {
    return [
      files.migrated,
      files.total,
      files.percentage,
      lines.migrated,
      lines.total,
      lines.percentage,
    ].join(' ');
  }
}

/// This class formats in a clear, human-readable format.
class HumanOutputFormatter implements OutputFormatter {
  const HumanOutputFormatter();

  @override
  String format({
    required files,
    required lines,
  }) {
    return [
      'Migrated files: ${files.migrated}',
      'Total files: ${files.total}',
      'Null safety percentage (files): ${files.percentage}%',
      'Migrated lines: ${lines.migrated}',
      'Total lines: ${lines.total}',
      'Null safety percentage (lines): ${lines.percentage}%',
    ].join('\n');
  }
}

/// This class formats the results as JSON.
class JsonOutputFormatter implements OutputFormatter {
  const JsonOutputFormatter();

  @override
  String format({
    required files,
    required lines,
  }) {
    return json.encode(<String, dynamic>{
      'files': {
        'migrated': files.migrated,
        'total': files.total,
        'percentage': files.percentage,
      },
      'lines': {
        'migrated': lines.migrated,
        'total': lines.total,
        'percentage': lines.percentage,
      },
    });
  }
}
