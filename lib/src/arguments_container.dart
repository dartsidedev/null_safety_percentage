import 'output_format.dart';

class ArgumentsContainer {
  ArgumentsContainer({
    required this.paths,
    this.outputFormat = OutputFormat.human,
    this.verbose = false,
    this.help = false,
    this.version = false,
  });

  final List<String> paths;
  final bool verbose;
  final bool help;
  final bool version;
  final OutputFormat outputFormat;

  @override
  String toString() {
    final sb = StringBuffer('$ArgumentsContainer(')
      ..write('paths: $paths, ')
      ..write('outputFormat: $outputFormat, ')
      ..write('verbose: $verbose, ')
      ..write('help: $help, ')
      ..write('version: $version')
      ..write(')');
    return '$sb';
  }
}
