import 'package:null_safety_percentage/src/null_safety_percentage.dart';
import 'package:test/test.dart';

void main() {
  group('help', () {
    test('is not empty', () {
      expect(help, isNotEmpty);
    });
  });

  group(parser, () {
    test('creates usage', () {
      expect(parser.usage, isNotEmpty);
    });
    test('output-format', () {
      expect(parser.options['output-format'], isNotNull);
    });

    test('help', () {
      expect(parser.options['help'], isNotNull);
    });

    test('version', () {
      expect(parser.options['version'], isNotNull);
    });
  });

  group(parseArguments, () {
    _check(String description, List<String> input, _Predicate outputPredicate) {
      test('$description for $input', () {
        expect(parseArguments(input), predicate(outputPredicate));
      });
    }

    _check('help', ['--help'], (a) => a.help);
    _check('version', ['--version'], (a) => a.version);
    _check('one directory', ['p'], (a) => a.paths.first == 'p');
    _check(
      'two directories',
      ['p1', 'p2'],
      (a) => a.paths[0] == 'p1' && a.paths[1] == 'p2',
    );

    _check(
      'two directories with custom ASCII formatter (lowercase)',
      ['p1', 'p2', '--output-format', 'ascii'],
      (a) =>
          a.paths[0] == 'p1' &&
          a.paths[1] == 'p2' &&
          a.outputFormat == OutputFormat.ascii,
    );

    _check(
      'two directories with custom JSON formatter (with equals)',
      ['p1', 'p2', '--output-format=json'],
      (a) =>
          a.paths[0] == 'p1' &&
          a.paths[1] == 'p2' &&
          a.outputFormat == OutputFormat.json,
    );
  });

  group(Argument, () {
    test('toString', () {
      expect(
        Argument(
          paths: ['lib', 'test'],
          outputFormat: OutputFormat.json,
          help: false,
          version: false,
        ).toString(),
        'Argument(paths: ["lib", "test"], outputFormat: OutputFormat.json, help: false, version: false)',
      );
    });
  });

  group('formatter', () {
    test('returns $AsciiOutputFormatter for ${OutputFormat.ascii}', () {
      expect(OutputFormat.ascii.formatter, isA<AsciiOutputFormatter>());
    });

    test('returns $HumanOutputFormatter for ${OutputFormat.human}', () {
      expect(OutputFormat.human.formatter, isA<HumanOutputFormatter>());
    });

    test('returns $AsciiOutputFormatter for ${OutputFormat.json}', () {
      expect(OutputFormat.json.formatter, isA<JsonOutputFormatter>());
    });
  });

  group('String.toOutputFormat', () {
    test('converts "ascii"', () {
      expect('ascii'.toOutputFormat(), OutputFormat.ascii);
    });

    test('converts "human"', () {
      expect('human'.toOutputFormat(), OutputFormat.human);
    });

    test('converts "json"', () {
      expect('json'.toOutputFormat(), OutputFormat.json);
    });

    test('throws exception for invalid string', () {
      expect(() => 'josn'.toOutputFormat(), throwsA(isA<Exception>()));
    });
  });

  final overview = Overview(
    lines: Coverage(migrated: 34567, total: 123000),
    files: Coverage(migrated: 543, total: 1001),
  );

  group(AsciiOutputFormatter, () {
    test('formats so that it is easy to manipulate with Shell tools', () {
      expect(
        const AsciiOutputFormatter().format(overview),
        '543 1001 54.25 34567 123000 28.1',
      );
    });
  });

  group(HumanOutputFormatter, () {
    test('formats in human-readable format', () {
      expect(
        const HumanOutputFormatter().format(overview),
        'Migrated files: 543\n'
        'Total files: 1001\n'
        'Null safety percentage (files): 54.25%\n'
        'Migrated lines: 34567\n'
        'Total lines: 123000\n'
        'Null safety percentage (lines): 28.1%',
      );
    });
  });

  group(JsonOutputFormatter, () {
    test('formats so that it is easy to manipulate with Shell tools', () {
      expect(
        const JsonOutputFormatter().format(overview),
        '{"files":{"migrated":543,"total":1001,"percentage":54.25},"lines":{"migrated":34567,"total":123000,"percentage":28.1}}',
      );
    });
  });

  group('$Overview $Coverage', () {
    test('registerFile', () {
      final overview = Overview()
        ..registerFile(linesCount: 1, migrated: true)
        ..registerFile(linesCount: 2, migrated: true)
        ..registerFile(linesCount: 1, migrated: false);

      expect(overview.files.total, 3);
      expect(overview.files.migrated, 2);
      expect(overview.files.percentage, 66.67);

      expect(overview.lines.total, 4);
      expect(overview.lines.migrated, 3);
      expect(overview.lines.percentage, 75.00);
    });

    test('add', () {
      final o1 = Overview(
        files: Coverage(total: 2, migrated: 1),
        lines: Coverage(total: 4, migrated: 2),
      );
      final o2 = Overview(
        files: Coverage(total: 2, migrated: 2),
        lines: Coverage(total: 4, migrated: 4),
      );
      final o = o1 + o2;
      expect(o.files.total, 4);
      expect(o.files.migrated, 3);
      expect(o.lines.total, 8);
      expect(o.lines.migrated, 6);
    });
  });

  group(isMigrated, () {
    test('simple migrated code', () {
      expect(isMigrated(['String? x = null;']), true);
    });

    test('empty file', () {
      expect(isMigrated(['']), true);
    });

    test('empty list', () {
      expect(isMigrated([]), true);
    });

    test('with old language version comment', () {
      expect(isMigrated(['// @dart=2.9', 'String a = null;']), false);
    });

    test('with comments before older language version comment', () {
      expect(
        isMigrated([
          '/// This library does foo for bar',
          '// @dart=2.9',
          'String b = null;',
        ]),
        false,
      );
    });

    test('with language version comment after empty lines', () {
      expect(
        isMigrated([
          '',
          '  ',
          '',
          '// @dart = 2.7',
          'bool b = null;',
        ]),
        false,
      );
    });

    test('migrated code after comments and empty lines', () {
      expect(
        isMigrated([
          '/// This library fooes your bar with baz',
          '// @TODO: Ticket number 123',
          '',
          '  ',
          'String? b => null;',
        ]),
        true,
      );
    });

    test('invalid language version comment (after code)', () {
      expect(
        isMigrated([
          '',
          '// comment',
          'String? g = null;',
          '// @dart=2.9',
          'String a = null;',
        ]),
        true,
      );
    });

    test('star-comment and old language version comment', () {
      expect(
        isMigrated([
          ' /** This is also a comment */',
          '// comment',
          '// @dart=2.9',
          'String a = null;',
        ]),
        false,
      );
    });

    test('star-comment and comment', () {
      expect(
        isMigrated([
          ' /** This is also a comment */',
          '// comment',
          '',
          'String? a = null;',
        ]),
        true,
      );
    });
  });
}

typedef _Predicate = bool Function(Argument a);
