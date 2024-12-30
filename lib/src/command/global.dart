import 'package:args/args.dart';

class GlobalArgs {
  GlobalArgs(this.argParser);
  final ArgParser argParser;

  void addVerboseFlag() {
    argParser.addFlag('verbose', abbr: 'v', negatable: false);
  }

  void addDebugFlag() {
    argParser.addFlag('debug', abbr: 'd', negatable: false);
  }
}

class GlobalResults {
  GlobalResults(this.argResults);
  final ArgResults? argResults;
}
