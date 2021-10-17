import 'dart:io';

import 'package:null_safety_percentage/null_safety_percentage.dart';

Future<void> main(List<String> arguments) async {
  late ArgumentsContainer args;

  void print(String message) {
    stdout.writeln(message);
  }

  void printVerbose(String message) {
    if (args.verbose) stdout.writeln(message);
  }

  void printError(String message) {
    stderr.writeln(message);
    exitCode = 2;
  }

  try {
    args = parseArguments(arguments);
  } on FormatException catch (fe) {
    printError('Could not parse arguments. $fe');
    printError(
        'For help, execute one of the following (depending on your installation method):');
    printError('\$ $name -h');
    printError('\$ dart run $name -h');
    printError('\$ flutter run $name -h');
    return;
  }

  printVerbose('Parsed arguments: $args');

  if (args.help) return stdout.write(help);
  if (args.version) return stdout.write(version);
  if (args.paths.isEmpty) {
    stderr.writeln('No directories specified');
    exitCode = 2;
    return;
  }

  final linesOverview = MigrationOverview();
  final filesOverview = MigrationOverview();

  final futures = args.paths.map((path) async {
    try {
      final directory = Directory(path);
      printVerbose('Read directory $path');
      final files = directory
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .toList();
      printVerbose('Files in directory $path: $files');
      for (final file in files) {
        final lines = file.readAsLinesSync();
        filesOverview.total++;
        linesOverview.total += lines.length;
        final migrated = isMigrated(lines);
        if (migrated) {
          filesOverview.migrated++;
          linesOverview.migrated += lines.length;
        }
      }
    } on FileSystemException catch (fse) {
      printError(
          'FileSystemException for $path. ${fse.message}. ${fse.osError?.message}.');
    }
  });

  await Future.wait(futures);

  final formatter = args.outputFormat.formatter;
  print(formatter.format(files: filesOverview, lines: linesOverview));
}
