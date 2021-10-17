# `null_safety_percentage`

> Command-line tool to provide null-safety percentage info of a project. Track your migration progress on mixed-version programs that execute with unsound null safety.

[![Continuous Integration](https://github.com/dartsidedev/null_safety_percentage/workflows/Continuous%20Integration/badge.svg?branch=main)](https://github.com/dartsidedev/null_safety_percentage/actions) [![codecov](https://codecov.io/gh/dartsidedev/null_safety_percentage/branch/main/graph/badge.svg)](https://codecov.io/gh/dartsidedev/null_safety_percentage) [![null_safety_percentage](https://img.shields.io/pub/v/null_safety_percentage?label=null_safety_percentage&logo=dart)](https://pub.dev/packages/null_safety_percentage 'See null_safety_percentage package info on pub.dev') [![Published by dartside.dev](https://img.shields.io/static/v1?label=Published%20by&message=dartside.dev&logo=dart&logoWidth=30&color=40C4FF&labelColor=1d599b&labelWidth=100)](https://pub.dev/publishers/dartside.dev/packages) [![GitHub Stars Count](https://img.shields.io/github/stars/dartsidedev/null_safety_percentage?logo=github)](https://github.com/dartsidedev/null_safety_percentage 'Star me on GitHub!')

## Important links

* [Read the source code and **star the repo** on GitHub](https://github.com/dartsidedev/null_safety_percentage)
* [Open an issue on GitHub](https://github.com/dartsidedev/null_safety_percentage/issues)
* [See package on `pub.dev`](https://pub.dev/packages/null_safety_percentage)
* [Read the docs on `pub.dev`](https://pub.dev/documentation/null_safety_percentage/latest/)
* [Flutter Docs on "JSON and serialization"](https://flutter.dev/docs/development/data-and-backend/json)
* [`dart:convert` library docs](https://api.dart.dev/stable/2.12.2/dart-convert/dart-convert-library.html)
* [Dart Docs `pub run`](https://dart.dev/tools/pub/cmd/pub-run)

## Motivation

## Usage

Install the `null_safety_percentage` command-line tool either globally or as a dev dependency.

### `null_safety_percentage` command-line tool

Keep in mind that how you invoke the `null_safety_percentage` depends on how you installed it and whether you are using it from a Flutter or Dart project.

#### Global installation

If you install `null_safety_percentage` globally, you can execute it simply by typing `null_safety_percentage lib test`.

```
dart pub global activate null_safety_percentage # or: flutter pub global activate null_safety_percentage

null_safety_percentage --help
null_safety_percentage --version

null_safety_percentage lib
null_safety_percentage lib test
null_safety_percentage --output-format json lib test
null_safety_percentage --output-format=json lib test
null_safety_percentage --output-format human --verbose lib
```

#### As dev dependency

You can run Dart scripts from your dependencies using the `dart run` or `flutter run` command.

1. Add `null_safety_percentage` to your `dev_dependencies`: `dart pub add -d null_safety_percentage` or `flutter pub add -d null_safety_percentage`.
2. Run the script `dart run null_safety_percentage lib test` or `flutter run null_safety_percentage lib test`. See more example scripts above.

## `example`

Don't forget the project's [`example`](https://github.com/dartsidedev/null_safety_percentage/tree/master/example) folder for a project where you can test the command-line tool.
