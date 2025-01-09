import 'package:args/args.dart';
import 'package:promptly/src/framework/framework.dart';

/// A class that encapsulates global arguments for a command-line application.
///
/// This class provides methods to add common global flags and options to an
/// [ArgParser] instance.
///
/// Example usage:
/// ```dart
/// final argParser = ArgParser();
/// final globalArgs = GlobalArgs(argParser);
/// globalArgs.addVerboseFlag();
/// globalArgs.addDebugFlag();
/// globalArgs.addLogLevel();
/// ```
///
/// The following global arguments are supported:
/// - `verbose` (`-v`): Print verbose output.
/// - `debug` (`-d`): Print debug output.
/// - `log-level` (`-l`): Set the log level. Allowed values are defined in the
///   [LogLevel] enum, with a default value of `LogLevel.error`.
class GlobalArgs {
  /// Creates a new instance of [GlobalArgs] with the given [ArgParser].
  ///
  /// The [argParser] parameter is required and must not be null.
  GlobalArgs(this.argParser);

  final ArgParser argParser;

  /// Adds a `verbose` flag to the [argParser].
  ///
  /// The `verbose` flag is used to enable verbose output. It is represented by
  /// the `-v` abbreviation and is not negatable.
  void addVerboseFlag() {
    argParser.addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Print verbose output.',
    );
  }

  /// Adds a `debug` flag to the [argParser].
  ///
  /// The `debug` flag is used to enable debug output. It is represented by
  /// the `-d` abbreviation and is not negatable.
  void addDebugFlag() {
    argParser.addFlag(
      'debug',
      abbr: 'd',
      negatable: false,
      help: 'Print debug output.',
    );
  }

  /// Adds a `log-level` option to the [argParser].
  ///
  /// The `log-level` option is used to set the log level. It is represented by
  /// the `-l` abbreviation. The allowed values are defined in the [LogLevel]
  /// enum, and the default value is `LogLevel.error`.
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
