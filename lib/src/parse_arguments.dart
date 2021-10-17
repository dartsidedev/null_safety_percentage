import 'arg_parser.dart';
import 'arguments_container.dart';
import 'output_format.dart';

/// Parse CLI arguments into typed [ArgumentsContainer].
ArgumentsContainer parseArguments(List<String> arguments) {
  final r = parser.parse(arguments);
  return ArgumentsContainer(
    paths: r.rest,
    outputFormat: (r['output-format'] as String).toOutputFormat(),
    verbose: r['verbose'] as bool,
    help: r['help'] as bool,
    version: r['version'] as bool,
  );
}
