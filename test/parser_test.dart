import 'package:null_safety_percentage/null_safety_percentage.dart';
import 'package:test/test.dart';

void main() {
  group('$parser', () {
    test('creates usage', () {
      expect(parser.usage, isNotEmpty);
    });

    group('has option for', () {
      test('output-format', () {
        expect(parser.options['output-format'], isNotNull);
      });

      test('verbose', () {
        expect(parser.options['verbose'], isNotNull);
      });

      test('help', () {
        expect(parser.options['help'], isNotNull);
      });

      test('version', () {
        expect(parser.options['version'], isNotNull);
      });
    });
  });
}
