import 'package:example/example.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final awesome = Awesome();
    test('First Test', () {
      expect(awesome.isAwesome, isTrue);
    });
  });
}
