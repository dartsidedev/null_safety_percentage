/// Checks whether [lines] of Dart code is migrated.
///
/// It is a pretty "naive" way of testing, but so far it's been good enough.
///
/// If you find a check that we could use that is better aligned with the Dart
/// compiler/AST/language server (no idea), open an issue or pull request.
bool isMigrated(List<String> lines) {
  for (final line in lines) {
    if (line.trim().isEmpty) continue;
    if (line.isOldLanguageVersionComment) return false;
    if (line.isComment) continue;
    return true;
  }
  return true;
}

extension on String {
  /// Checks whether a string is a language version comments with non-null-safe
  /// version in it.
  bool get isOldLanguageVersionComment => _oldVersions.contains(trim());

  /// Checks whether a string is a Dart comment.
  ///
  /// This does not take care of multiline /* */ comments with but as it is
  /// discouraged by the Dart style guide, I don't care for now.
  bool get isComment {
    final t = trim();
    return t.startsWith('/*') && t.endsWith('*/') || t.startsWith('//');
  }
}

/// List of language version comments that are non-null-safe.
const _oldVersions = <String>[
  // Migration tool default value is 2.9, so it's best to have that in the
  // first position (it's faster).
  '// @dart=2.9',
  '// @dart = 2.9',
  '// @dart=2.10',
  '// @dart = 2.10',
  '// @dart=2.8',
  '// @dart = 2.8',
  '// @dart=2.7',
  '// @dart = 2.7',
  '// @dart=2.6',
  '// @dart = 2.6',
  '// @dart=2.5',
  '// @dart = 2.5',
  '// @dart=2.4',
  '// @dart = 2.4',
  '// @dart=2.3',
  '// @dart = 2.3',
  '// @dart=2.2',
  '// @dart = 2.2',
  '// @dart=2.1',
  '// @dart = 2.1',
  '// @dart=2.0',
  '// @dart = 2.0',
];
