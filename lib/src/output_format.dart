import 'output_formatters.dart';

enum OutputFormat {
  ascii,
  human,
  json,
}

extension ToOutputFormat on String {
  OutputFormat toOutputFormat() {
    switch (this) {
      case 'ascii':
        return OutputFormat.ascii;
      case 'human':
        return OutputFormat.human;
      case 'json':
        return OutputFormat.json;
    }
    throw Exception('Invalid output format');
  }
}

extension GetOutputFormatter on OutputFormat {
  OutputFormatter get formatter {
    switch (this) {
      case OutputFormat.ascii:
        return OutputFormatter.ascii;
      case OutputFormat.human:
        return OutputFormatter.human;
      case OutputFormat.json:
        return OutputFormatter.json;
    }
  }
}
