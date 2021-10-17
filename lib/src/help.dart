import 'arg_parser.dart';
import 'pubspec_info.dart';

String get help {
  final s = StringBuffer()
    ..writeln('PACKAGE')
    ..writeln(name)
    ..writeln()
    ..writeln('DESCRIPTION')
    ..writeln(description)
    ..writeln()
    ..writeln('USAGE')
    ..writeln('  \$ $name [arguments] <paths>')
    ..writeln(
        'Depending on the installation method, the following could be necessary:')
    ..writeln('  \$ dart run $name [arguments] <paths>')
    ..writeln('  \$ flutter run $name [arguments] <paths>')
    ..writeln()
    ..writeln('EXAMPLES')
    ..writeln('Null-safety migration progress report in human-readable format')
    ..writeln('  \$ $name lib test')
    ..writeln('Null-safety migration progress report in JSON format')
    ..writeln('  \$ $name lib test --output-format json')
    ..writeln('Null-safety migration progress report in ASCII format')
    ..writeln('  \$ $name lib test --output-format ascii')
    ..writeln()
    ..writeln('OPTIONS')
    ..writeln(parser.usage)
    ..writeln()
    ..writeln('RESOURCES')
    ..writeln('Source code: $homepage')
    ..writeln('Issue tracker: $issueTracker')
    ..writeln('Package info: https://pub.dev/packages/$name');
  return '$s';
}
