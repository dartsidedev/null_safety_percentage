import 'package:null_safety_percentage/null_safety_percentage.dart';
import 'package:test/test.dart';

void main() {
  final lines = MigrationOverview()
    ..migrated = 34567
    ..total = 123000;
  final files = MigrationOverview()
    ..migrated = 543
    ..total = 1001;

  group('$AsciiOutputFormatter', () {
    test('formats so that it is easy to manipulate with Shell tools', () {
      expect(
        AsciiOutputFormatter().format(lines: lines, files: files),
        '543 1001 54.25 34567 123000 28.1',
      );
    });
  });

  group('$HumanOutputFormatter', () {
    test('formats in human-readable format', () {
      expect(
        HumanOutputFormatter().format(lines: lines, files: files),
        'Migrated files: 543\n'
        'Total files: 1001\n'
        'Null safety percentage (files): 54.25%\n'
        'Migrated lines: 34567\n'
        'Total lines: 123000\n'
        'Null safety percentage (lines): 28.1%',
      );
    });
  });

  group('$JsonOutputFormatter', () {
    test('formats so that it is easy to manipulate with Shell tools', () {
      expect(
        JsonOutputFormatter().format(lines: lines, files: files),
        '{"files":{"migrated":543,"total":1001,"percentage":54.25},"lines":{"migrated":34567,"total":123000,"percentage":28.1}}',
      );
    });
  });
}
