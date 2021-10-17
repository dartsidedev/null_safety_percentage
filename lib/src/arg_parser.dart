import 'package:args/args.dart';

final parser = ArgParser()
  ..addOption('output-format',
      help: 'Set the output format',
      allowed: ['human', 'ascii', 'json'],
      defaultsTo: 'human')
  ..addFlag(
    'verbose',
    abbr: 'v',
    help: 'Set output to verbose.',
    defaultsTo: false,
    negatable: false,
  )
  ..addFlag(
    'help',
    abbr: 'h',
    help: 'Print this usage information.',
    defaultsTo: false,
    negatable: false,
  )
  ..addFlag(
    'version',
    help: 'Report the version of the null_safety_coverage tool.',
    defaultsTo: false,
    negatable: false,
  );
