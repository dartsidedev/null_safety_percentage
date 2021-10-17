import 'package:null_safety_percentage/null_safety_percentage.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

typedef ArgumentsContainerPredicate = bool Function(ArgumentsContainer ac);

void main() {
  group('$parseArguments', () {
    @isTest
    testParseArguments(
      String description,
      List<String> input,
      ArgumentsContainerPredicate outputPredicate,
    ) {
      final d = '$description for $input';
      test(d, () {
        expect(parseArguments(input), predicate(outputPredicate), reason: d);
      });
    }

    testParseArguments(
      'verbose',
      ['--verbose'],
      (ac) => ac.verbose,
    );

    testParseArguments(
      'verbose',
      ['--help'],
      (ac) => ac.help,
    );

    testParseArguments(
      'verbose',
      ['--version'],
      (ac) => ac.version,
    );

    testParseArguments(
      'one directory',
      ['package/lib'],
      (ac) => ac.paths.first == 'package/lib',
    );

    testParseArguments(
      'two directories',
      ['p1/lib', 'p2/lib'],
      (ac) =>
          ac.paths[0] == 'p1/lib' &&
          ac.paths[1] == 'p2/lib' &&
          !ac.verbose &&
          ac.outputFormat == OutputFormat.human,
    );

    testParseArguments(
      'two directories with verbose flag',
      ['p1/lib', 'p2/lib', '--verbose'],
      (ac) =>
          ac.paths[0] == 'p1/lib' &&
          ac.paths[1] == 'p2/lib' &&
          ac.verbose &&
          ac.outputFormat == OutputFormat.human,
    );

    testParseArguments(
      'two directories with custom ASCII formatter (lowercase)',
      ['p1/lib', 'p2/lib', '--output-format', 'ascii'],
      (ac) =>
          ac.paths[0] == 'p1/lib' &&
          ac.paths[1] == 'p2/lib' &&
          ac.outputFormat == OutputFormat.ascii,
    );

    testParseArguments(
      'two directories with custom JSON formatter (with equals)',
      ['p1/lib', 'p2/lib', '--output-format=json'],
      (ac) =>
          ac.paths[0] == 'p1/lib' &&
          ac.paths[1] == 'p2/lib' &&
          ac.outputFormat == OutputFormat.json,
    );
  });
}
