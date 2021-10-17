import 'package:test/test.dart';
import 'package:null_safety_percentage/null_safety_percentage.dart';

void main() {
  group('$MigrationOverview', () {
    test('returns percentage', () {
      final m = MigrationOverview()
        ..total = 2
        ..migrated = 1;
      expect(m.percentage, 50);
    });

    test('allows increment', () {
      final m = MigrationOverview();
      m.total += 2;
      m.migrated++;
      expect(m.percentage, 50);
    });

    test('truncates result to 2 fraction digits', () {
      final m = MigrationOverview()
        ..total = 3
        ..migrated = 1;
      expect(m.percentage, 33.33);
    });
  });
}
