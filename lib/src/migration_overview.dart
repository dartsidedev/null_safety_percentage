class MigrationOverview {
  int total = 0;
  int migrated = 0;

  double get percentage =>
      double.parse((migrated / total * 100).toStringAsFixed(2));
}
