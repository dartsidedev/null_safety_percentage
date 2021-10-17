import 'package:null_safety_percentage/null_safety_percentage.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

void main() {
  group('$OutputFormat', () {
    group('formatter', () {
      @isTest
      testFormatter(
        String description,
        OutputFormat format,
        TypeMatcher type,
      ) {
        final d = 'returns $type for $format - $description';
        test('returns $type for $format', () {
          expect(format.formatter, type, reason: d);
        });
      }

      testFormatter('ascii', OutputFormat.ascii, isA<AsciiOutputFormatter>());
      testFormatter('human', OutputFormat.human, isA<HumanOutputFormatter>());
      testFormatter('json', OutputFormat.json, isA<JsonOutputFormatter>());
    });
  });

  group('String.toOutputFormat', () {
    @isTest
    testToOutputFormat(
      String description,
      String input,
      OutputFormat output,
    ) {
      final d = 'converts "$input" to $output - $description';
      test(d, () {
        expect(input.toOutputFormat(), output, reason: d);
      });
    }

    testToOutputFormat('ascii', 'ascii', OutputFormat.ascii);
    testToOutputFormat('human', 'human', OutputFormat.human);
    testToOutputFormat('json', 'json', OutputFormat.json);

    test('throws exception for invalid string', () {
      expect(() => 'josn'.toOutputFormat(), throwsA(isA<Exception>()));
    });
  });
}
