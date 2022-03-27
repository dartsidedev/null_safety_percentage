import 'dart:convert';

import 'package:args/args.dart';

import 'pubspec_info.dart';

String get help {
  final s = StringBuffer()
    ..writeln('PACKAGE')
    ..writeln(name)
    ..writeln()
    ..writeln('DESCRIPTION')
    ..writeln(description)
    ..writeln()
    ..writeln('USAGE')
    ..writeln('  \$ $name [arguments] <paths>')
    ..writeln(
        'Depending on the installation method, the following could be necessary:')
    ..writeln('  \$ dart run $name [arguments] <paths>')
    ..writeln('  \$ flutter run $name [arguments] <paths>')
    ..writeln()
    ..writeln('EXAMPLES')
    ..writeln('Null-safety migration progress report in human-readable format')
    ..writeln('  \$ $name lib test')
    ..writeln('Null-safety migration progress report in JSON format')
    ..writeln('  \$ $name lib test --output-format json')
    ..writeln('Null-safety migration progress report in ASCII format')
    ..writeln('  \$ $name lib test --output-format ascii')
    ..writeln()
    ..writeln('OPTIONS')
    ..writeln(parser.usage)
    ..writeln()
    ..writeln('RESOURCES')
    ..writeln('Source code: $homepage')
    ..writeln('Issue tracker: $issueTracker')
    ..writeln('Package info: https://pub.dev/packages/$name');
  return '$s';
}

final parser = ArgParser()
  ..addOption(
    'output-format',
    help: 'Set the output format',
    allowed: [
      'human',
      'ascii',
      'json',
    ],
    defaultsTo: 'human',
  )
  ..addFlag(
    'help',
    abbr: 'h',
    help: 'Print this usage information.',
    defaultsTo: false,
    negatable: false,
  )
  ..addFlag(
    'version',
    help: 'Report the version of the null_safety_coverage tool.',
    defaultsTo: false,
    negatable: false,
  );

/// Parse CLI arguments into typed [Argument].
Argument parseArguments(List<String> arguments) {
  final r = parser.parse(arguments);
  return Argument(
    paths: r.rest,
    outputFormat: (r['output-format'] as String).toOutputFormat(),
    help: r['help'] as bool,
    version: r['version'] as bool,
  );
}

class Argument {
  Argument({
    required this.paths,
    this.outputFormat = OutputFormat.human,
    this.help = false,
    this.version = false,
  });

  final List<String> paths;
  final bool help;
  final bool version;
  final OutputFormat outputFormat;

  @override
  String toString() {
    final sb = StringBuffer('$Argument(')
      ..write('paths: [${paths.map((p) => '"$p"').join(', ')}], ')
      ..write('outputFormat: $outputFormat, ')
      ..write('help: $help, ')
      ..write('version: $version')
      ..write(')');
    return '$sb';
  }
}

enum OutputFormat { ascii, human, json }

extension GetOutputFormatter on OutputFormat {
  OutputFormatter get formatter {
    switch (this) {
      case OutputFormat.ascii:
        return AsciiOutputFormatter();
      case OutputFormat.human:
        return HumanOutputFormatter();
      case OutputFormat.json:
        return JsonOutputFormatter();
    }
  }
}

extension ToOutputFormat on String {
  OutputFormat toOutputFormat() {
    switch (this) {
      case 'ascii':
        return OutputFormat.ascii;
      case 'human':
        return OutputFormat.human;
      case 'json':
        return OutputFormat.json;
    }
    throw Exception('Invalid output format');
  }
}

abstract class OutputFormatter {
  String format(Overview overview);
}

/// This class formats the results so that it is easy to manipulate with
/// different Unix shell tools.
class AsciiOutputFormatter implements OutputFormatter {
  const AsciiOutputFormatter();

  @override
  String format(Overview overview) {
    return [
      overview.files.migrated,
      overview.files.total,
      overview.files.percentage,
      overview.lines.migrated,
      overview.lines.total,
      overview.lines.percentage,
    ].join(' ');
  }
}

/// This class formats in a clear, human-readable format.
class HumanOutputFormatter implements OutputFormatter {
  const HumanOutputFormatter();

  @override
  String format(Overview overview) {
    return [
      'Migrated files: ${overview.files.migrated}',
      'Total files: ${overview.files.total}',
      'Null safety percentage (files): ${overview.files.percentage}%',
      'Migrated lines: ${overview.lines.migrated}',
      'Total lines: ${overview.lines.total}',
      'Null safety percentage (lines): ${overview.lines.percentage}%',
    ].join('\n');
  }
}

/// This class formats the results as JSON.
class JsonOutputFormatter implements OutputFormatter {
  const JsonOutputFormatter();

  @override
  String format(Overview overview) {
    return json.encode(<String, dynamic>{
      'files': {
        'migrated': overview.files.migrated,
        'total': overview.files.total,
        'percentage': overview.files.percentage,
      },
      'lines': {
        'migrated': overview.lines.migrated,
        'total': overview.lines.total,
        'percentage': overview.lines.percentage,
      },
    });
  }
}

class Overview {
  Overview({
    Coverage? files,
    Coverage? lines,
  })  : files = files ?? Coverage(),
        lines = lines ?? Coverage();

  final Coverage files;
  final Coverage lines;

  void registerFile({required int linesCount, required bool migrated}) {
    files.register(migrated, 1);
    lines.register(migrated, linesCount);
  }

  Overview operator +(Overview other) {
    return Overview(
      files: files + other.files,
      lines: lines + other.lines,
    );
  }
}

class Coverage {
  Coverage({this.total = 0, this.migrated = 0});

  int total;
  int migrated;

  double get percentage =>
      double.parse((migrated / total * 100).toStringAsFixed(2));

  void register(bool isMigrated, int count) {
    if (isMigrated) migrated += count;
    total += count;
  }

  Coverage operator +(Coverage other) {
    return Coverage(
      total: total + other.total,
      migrated: migrated + other.migrated,
    );
  }
}

/// Checks whether [lines] of Dart code is migrated.
///
/// It is a pretty "naive" way of testing, but so far it's been good enough.
///
/// If you find a check that we could use that is better aligned with the Dart
/// compiler/AST/language server (no idea), open an issue or pull request.
bool isMigrated(List<String> lines) {
  for (final line in lines) {
    if (line.trim().isEmpty) continue;
    if (line.isOldLanguageVersionComment) return false;
    if (line.isComment) continue;
    return true;
  }
  return true;
}

extension on String {
  /// Checks whether a string is a language version comments with non-null-safe
  /// version in it.
  bool get isOldLanguageVersionComment => _oldVersions.contains(trim());

  /// Checks whether a string is a Dart comment.
  ///
  /// This does not take care of multiline /* */ comments with but as it is
  /// discouraged by the Dart style guide, I don't care for now.
  bool get isComment {
    final t = trim();
    return t.startsWith('/*') && t.endsWith('*/') || t.startsWith('//');
  }
}

/// List of language version comments that are non-null-safe.
const _oldVersions = <String>[
  '// @dart=2.9',
  '// @dart = 2.9',
  '// @dart=2.10',
  '// @dart = 2.10',
  '// @dart=2.8',
  '// @dart = 2.8',
  '// @dart=2.7',
  '// @dart = 2.7',
  '// @dart=2.6',
  '// @dart = 2.6',
  '// @dart=2.5',
  '// @dart = 2.5',
  '// @dart=2.4',
  '// @dart = 2.4',
  '// @dart=2.3',
  '// @dart = 2.3',
  '// @dart=2.2',
  '// @dart = 2.2',
  '// @dart=2.1',
  '// @dart = 2.1',
  '// @dart=2.0',
  '// @dart = 2.0',
];
