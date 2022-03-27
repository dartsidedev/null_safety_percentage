import 'dart:io';

import 'package:compute/compute.dart';
import 'package:null_safety_percentage/src/null_safety_percentage.dart';
import 'package:null_safety_percentage/src/pubspec_info.dart';

Future<void> main(List<String> arguments) async {
  late Argument args;

  try {
    args = parseArguments(arguments);
  } on FormatException catch (fe) {
    return printError(
      'Could not parse arguments. $fe\n'
      'For help, execute one of the following (depending on your installation method):\n'
      '\$ $name -h\n'
      '\$ dart run $name -h\n'
      '\$ flutter run $name -h\n',
    );
  }

  if (args.help) return print(help);
  if (args.version) return print(version);
  if (args.paths.isEmpty) return printError('No directories specified');

  args.paths
      .map((path) => Directory(path))
      .map((directory) => directory.dartFiles)
      .flatten()
      .map((file) => compute(examineFile, file))
      .toStream()
      .fold<Overview>(Overview(), (overview, report) => overview..add(report))
      .use(args.outputFormat.formatter.format)
      .use(print);
}

void print(String message) {
  stdout.writeln(message);
}

void printError(String message) {
  stderr.writeln(message);
  exitCode = 2;
}

FileReport examineFile(File file) => file.readAsLinesSync().use(
    (lines) => FileReport(lines: lines.length, migrated: isMigrated(lines)));

extension AsyncUse<T> on Future<T> {
  Future<U> use<U>(U Function(T value) function) async => function(await this);
}

extension Use<T> on T {
  U use<U>(U Function(T value) function) => function(this);
}

extension ToStreamExtension<T> on Iterable<Future<T>> {
  Stream<T> toStream() => Stream.fromFutures(this);
}

extension FlattenExtension<T> on Iterable<Iterable<T>> {
  Iterable<T> flatten() => expand((e) => e);
}

extension on Directory {
  Iterable<File> get dartFiles {
    return listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'));
  }
}
