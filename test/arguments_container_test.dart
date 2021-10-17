import 'package:null_safety_percentage/null_safety_percentage.dart';
import 'package:test/test.dart';

void main() {
  group('$ArgumentsContainer', () {
    test('toString', () {
      expect(
        ArgumentsContainer(
          paths: ['lib', 'test'],
          outputFormat: OutputFormat.json,
          verbose: true,
          help: false,
          version: false,
        ).toString(),
        'ArgumentsContainer(paths: ["lib", "test"], outputFormat: OutputFormat.json, verbose: true, help: false, version: false)',
      );
    });
  });
}
