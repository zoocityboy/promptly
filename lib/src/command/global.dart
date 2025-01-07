import 'package:args/args.dart';
import 'package:promptly/src/framework/framework.dart';

class GlobalArgs {
  GlobalArgs(this.argParser);
  final ArgParser argParser;

  void addVerboseFlag() {
    argParser.addFlag('verbose', abbr: 'v', negatable: false, help: 'Print verbose output.');
  }

  void addDebugFlag() {
    argParser.addFlag('debug', abbr: 'd', negatable: false, help: 'Print debug output.');
  }

  void addLogLevel() {
    argParser.addOption(
      'log-level',
      abbr: 'l',
      help: 'Set the log level.',
      allowed: LogLevel.values.map((e) => e.name).toList(),
      defaultsTo: LogLevel.error.name,
    );
  }
}

class GlobalResults {
  GlobalResults(this.argResults);
  final ArgResults? argResults;
}
