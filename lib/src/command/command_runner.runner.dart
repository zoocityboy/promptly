part of 'command_runner.dart';

/// A command runner that extends the `cr.CommandRunner` class with an integer
/// return type. This class is used to manage and execute a set of commands
/// within the application.
///
/// The `CommandRunner` class provides functionality to add commands, parse
/// command-line arguments, and execute the appropriate command based on the
/// input.
///
/// Example usage:
/// ```dart
/// void main(List<String> args) {
///   var runner = CommandRunner();
///   runner.addCommand(MyCommand());
///   runner.run(args);
/// }
/// ```
///
/// The `CommandRunner` class is typically used in command-line applications
/// to handle various commands and their respective options and arguments.
final _promptlyConsole = Console();

/// A logger instance for the Promptly application.
///
/// This logger uses a custom printer function that writes log messages
/// to the `_promptlyConsole`. The printer function takes two parameters:
/// - `level`: The log level of the message.
/// - `message`: The log message to be written to the console.
final _promptlyLogger = Logger();

class CommandRunner extends completion.CompletionCommandRunner<int> {
  CommandRunner(super.executableName, super.description, {this.version, Theme? theme, LogLevel? logLevel}) {
    logger.trace('Runner [$executableName] initialized');
    GlobalArgs(argParser).addLogLevel();
    _promptlyConsole.theme = theme ?? Theme.defaultTheme;
    _promptlyLogger
      ..level = logLevel ?? LogLevel.error
      ..printer = (item) {
        if (item.level.allowed(_promptlyLogger.level)) {
          _promptlyConsole.writeMessage(item.withTime());
        }
      };
  }

  final String? version;

  @override
  bool get enableAutoInstall => true;

  @override
  String? get usageFooter => '... Run `$executableName help` for more information.';

  Theme get theme => console.theme;

  String get appDescription {
    final StringBuffer buffer = StringBuffer();
    buffer.write(theme.prefixHeaderLine(console.theme.colors.successBlock(' $executableName ')));
    if (version != null) {
      buffer.write(' ');
      buffer.write(theme.colors.success('v$version'.bold()));
    }
    buffer.write(theme.colors.hint(' • '));
    buffer.writeln(theme.colors.hint(description));
    buffer.verticalLine();
    return buffer.toString();
  }

  @override
  String get invocation =>
      '${console.theme.colors.active('$executableName [command]')} ${console.theme.colors.hint('[...flags]')}';

  @override
  String get usage => appDescription + publicUsageWithoutDescription;

  int get getUsagePrefixLength => argParser.getPrefixLength;

  String get publicUsageWithoutDescription {
    final usegeLines = argParser.customUsage.split('\n');
    final buffer = StringBuffer();
    buffer
      ..write(
        getStyledCommandUsage(
          commands,
          lineLength: argParser.usageLineLength,
          helpUsageLength: getUsagePrefixLength,
        ),
      )
      ..verticalLine();
    if (usegeLines.isNotEmpty) {
      buffer
        ..write(console.theme.prefixSectionLine(console.theme.colors.sectionBlock(' Flags ')))
        ..newLine();
    }
    for (final line in usegeLines) {
      buffer
        ..write(console.theme.prefixLine(''))
        ..write(line)
        ..newLine();
    }
    buffer
      ..writeln(console.theme.prefixQuestion(invocation))
      ..newLine();

    if (usageFooter != null) {
      buffer
        ..verticalLine()
        ..write(console.theme.prefixLine(console.theme.colors.hint(usageFooter!)))
        ..newLine();
    }
    return buffer.toString();
  }

  /// Getter for the logger instance used in the application.
  ///
  /// Returns the `_promptlyLogger` instance which is used for logging purposes.
  Logger get logger => _promptlyLogger;

  @override
  void addCommand(args_command_runner.Command<int> command) {
    logger.trace('addCommand', commandName: command.name);
    super.addCommand(command);
  }

  @override
  Future<int> run(Iterable<String> args) async {
    int exitCode;
    try {
      final p = parse(args);
      final logLevel = p.option('log-level') ?? LogLevel.error.name;
      logger.level = LogLevel.values.byName(logLevel);
      final result = await runCommand(p) ?? ExitCode.success.code;
      exitCode = result;
    } on FormatException catch (e) {
      console
        ..writeMessage(e.message, style: MessageStyle.error)
        ..writeln('')
        ..write(usage);
      logger.trace(e.toString());
      exitCode = ExitCode.software.code;
    } on UsageException catch (e) {
      console
        ..writeMessage(e.message, style: MessageStyle.error)
        ..write(e.usage);
      logger.trace(e.toString());
      exitCode = ExitCode.software.code;
    } catch (e) {
      console.writeMessage(e.toString(), style: MessageStyle.error);
      logger.trace(e.toString());

      exitCode = ExitCode.software.code;
    }
    logger.flush();
    print('exitCode: $exitCode');
    return exitCode;
  }

  @override
  Future<int?> runCommand(args.ArgResults topLevelResults) async {
    if (topLevelResults.command?.name == 'completion') {
      await super.runCommand(topLevelResults);
      return ExitCode.success.code;
    }

    logger.trace('~ run command ${topLevelResults.command?.name}', commandName: topLevelResults.command?.name);
    final exitCode = await super.runCommand(topLevelResults);
    return exitCode;
  }

  Future<void> safeRun(List<String> args) {
    return flushThenExit(() => run(args));
  }

  @override
  Never usageException(String message) => throw UsageException(message, publicUsageWithoutDescription);
}

Future<dynamic> flushThenExit(Future<int> Function() status) {
  return Future.wait<void>([
    stdout.close(),
    stderr.close(),
  ]).then<void>((_) async {
    final result = await status();
    print('status: $result');
    exit(result);
  });
}
