import 'package:test/test.dart';
import 'package:meta/meta.dart';
import 'package:null_safety_percentage/null_safety_percentage.dart';

void main() {
  group('isMigrated', () {
    @isTest
    testIsMigrated(
      String description,
      List<String> input,
      bool output,
    ) {
      final d = 'returns $output for $input - $description';
      test(d, () {
        expect(isMigrated(input), output, reason: d);
      });
    }

    testIsMigrated(
      'empty file',
      [
        '',
      ],
      true,
    );

    testIsMigrated(
      'empty list',
      [],
      true,
    );

    testIsMigrated(
      'with older language version comment',
      [
        '// @dart=2.9',
        'String a = null;',
      ],
      false,
    );

    testIsMigrated(
      'with comments before older language version comment',
      [
        '/// This library does foo for bar',
        '// @dart=2.9',
        'String b = null;',
      ],
      false,
    );

    testIsMigrated(
      'with language version comment after empty lines',
      [
        '',
        '  ',
        '',
        '// @dart = 2.7',
        'bool b = null;',
      ],
      false,
    );

    testIsMigrated(
      'no comments, just migrated code',
      [
        'String? x = null;',
      ],
      true,
    );

    testIsMigrated(
      'migrated code after comments and empty lines',
      [
        '/// This library fooes your bar with baz',
        '// @TODO: Ticket number 123',
        '',
        '  ',
        'String? b => null;',
      ],
      true,
    );

    testIsMigrated(
      'invalid language version comment (after code)',
      [
        '',
        '// comment',
        'String? g = null;',
        '// @dart=2.9',
        'String a = null;',
      ],
      true,
    );

    testIsMigrated(
      'star-comment and language version comment',
      [
        ' /** This is also a comment */',
        '// comment',
        '// @dart=2.9',
        'String a = null;',
      ],
      false,
    );

    testIsMigrated(
      'star-comment and language version comment',
      [
        ' /** This is also a comment */',
        '// comment',
        '',
        'String? a = null;',
      ],
      true,
    );
  });
}
