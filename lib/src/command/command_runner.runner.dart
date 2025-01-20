part of 'command_runner.dart';

/// A command runner that extends the `args_command_runner.CommandRunner` class with an integer
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

void defaultPrinter(LogItem item) {
  if (!item.level.allowed(_promptlyLogger.level)) return;
  [LogLevel.error, LogLevel.fatal].contains(item.level)
      ? _promptlyConsole.writeMessage(item.withTime(), prefix: '', style: MessageStyle.error)
      : _promptlyConsole.writeMessage(item.withTime());
}

/// A command runner that extends the `CompletionCommandRunner` to provide
/// additional functionality for running commands with completion support.
///
/// The `CommandRunner` class is responsible for initializing the logger,
/// setting up the console theme, and managing the execution of commands.
/// It also provides methods for adding commands, running commands, and
/// handling usage exceptions.
///
/// The class includes the following features:
/// - Logger initialization and configuration
/// - Console theme setup
/// - Command execution with error handling
/// - Custom usage and invocation messages
/// - Support for command completion
///
/// Example usage:
/// ```dart
/// final runner = CommandRunner('myapp', 'A sample command-line application');
/// runner.addCommand(MyCommand());
/// runner.run(args);
/// ```
///
/// Properties:
/// - `version`: The version of the application.
/// - `enableAutoInstall`: Indicates whether auto-install is enabled.
/// - `theme`: The console theme used for styling output.
/// - `appDescription`: A formatted description of the application.
/// - `invocation`: The command invocation message.
/// - `usage`: The usage message for the application.
/// - `getUsagePrefixLength`: The length of the usage prefix.
/// - `publicUsageWithoutDescription`: The public usage message without the description.
/// - `logger`: The logger instance used for logging purposes.
///
/// Methods:
/// - `addCommand`: Adds a command to the runner.
/// - `run`: Runs the command with the given arguments.
/// - `runCommand`: Runs the specified command.
/// - `safeRun`: Runs the command safely and exits after flushing the logger.
/// - `usageException`: Throws a usage exception with the given message.

class CommandRunner extends completion.CompletionCommandRunner<int> {
  CommandRunner(
    super.executableName,
    super.description, {
    this.version,
    Theme? theme,
    LogLevel? logLevel,
    LogPrinter? printer,
  }) {
    logger.trace('Runner [$executableName] initialized');
    GlobalArgs(argParser).addLogLevel();
    _promptlyConsole.theme = theme ?? Theme.defaultTheme;
    _promptlyLogger
      ..level = logLevel ?? LogLevel.error
      ..printer = printer ?? defaultPrinter;
    _promptlyLogger.trace(LocaleInfo.env.toString());
    topLevelOptions = argParser.options;
  }

  final String? version;

  @override
  bool get enableAutoInstall => true;

  Map<String, args.Option>? topLevelOptions;

  // @override
  // String? get usageFooter => '... Run `$executableName help` for more information.';

  Theme get theme => console.theme;
  String _appDescription(StyleFunction style) {
    final StringBuffer buffer = StringBuffer();

    buffer.write(
      theme.prefixHeaderLine(
        style(' $executableName ').inverse(),
      ),
    );
    if (version != null) {
      buffer.write(' ');
      buffer.write(style('v$version'.bold()));
    }
    buffer.write(theme.colors.hint(' • '));
    buffer.writeln(theme.colors.hint(description));
    buffer.verticalLine();
    return buffer.toString();
  }

  String get appDescription => _appDescription(theme.colors.success);

  String get errorAppDescription => _appDescription(theme.colors.error);

  @override
  String get invocation =>
      '${console.theme.colors.active('$executableName [command]')} ${console.theme.colors.hint('[...flags]')}';

  @override
  String get usage => appDescription + publicUsageWithoutDescription;

  int get getUsagePrefixLength => argParser.getPrefixLength;

  String get publicUsageWithoutDescription {
    final usegeLines = argParser.customUsage.split('\n');
    // final usegeLines = argParser.usage.split('\n');
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
        ..section(' Flags ')
        ..newLine();
    }
    for (final line in usegeLines) {
      buffer
        ..prefixLine()
        ..write(line)
        ..newLine();
    }
    if (usageFooter != null) {
      buffer
        ..verticalLine()
        ..prefixLine()
        ..write(console.theme.colors.hint(usageFooter!))
        ..newLine()
        ..verticalLine();
    }
    buffer
      ..verticalLine()
      ..writeln(console.theme.prefixRun(invocation))
      ..newLine();

    return buffer.toString();
  }

  /// Getter for the logger instance used in the application.
  ///
  /// Returns the `_promptlyLogger` instance which is used for logging purposes.
  Logger get logger => _promptlyLogger;

  @override
  void addCommand(args_command_runner.Command<int> command) {
    final stopwatch = Stopwatch()..start();

    super.addCommand(command);
    stopwatch.stop();
    if (!['help', 'completion', 'install-completion-files', 'uninstall-completion-files'].contains(command.name)) {
      logger.trace('command added', commandName: command.name, durationInMilliseconds: stopwatch.elapsedMilliseconds);
    }
  }

  Future<void> safeRun(List<String> args) async {
    // ignore: deprecated_member_use_from_same_package
    return flushThenExit(await run(args));
  }

  @Deprecated('Do not use this method directly. Use `safeRun` instead.')
  @protected
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
        ..write(errorAppDescription)
        ..writeMessage(e.message, style: MessageStyle.error)
        ..writeln('')
        ..write(usage);
      logger.trace(e.toString());
      exitCode = ExitCode.software.code;
    } on UsageException catch (e) {
      console
        ..write(errorAppDescription)
        ..write(console.theme.prefixError(''))
        ..write(console.theme.colors.error(e.message.trimRight()))
        ..write('\n')
        // ..writeMessage(e.message, style: MessageStyle.error)
        ..write(e.usage);
      logger.trace(e.message);
      exitCode = ExitCode.software.code;
    } catch (e) {
      console
        ..write(errorAppDescription)
        ..writeMessage(e.toString(), style: MessageStyle.error);
      logger.trace(e.toString());

      exitCode = ExitCode.software.code;
    }
    logger.flush();
    stdout.write('\x1b[m');

    return exitCode;
  }

  @override
  Future<int?> runCommand(args.ArgResults topLevelResults) async {
    var commands = this.commands;
    print(topLevelResults);
    var argResults = topLevelResults;
    var commandString = executableName;
    args_command_runner.Command<int>? command;
    while (commands.isNotEmpty) {
      if (argResults.command == null) {
        if (argResults.rest.isEmpty) {
          if (command == null) {
            // No top-level command was chosen.
            printUsage();
            return null;
          }

          command.usageException('Missing subcommand for "$commandString".');
        } else {
          final requested = argResults.rest[0];

          // Build up a help message containing similar commands, if found.
          final similarCommands = _similarCommandsText<int>(requested, commands.values);

          if (command == null) {
            usageException(
              'Could not find a command named "$requested".$similarCommands',
            );
          }

          command.usageException('Could not find a subcommand named '
              '"$requested" for "$commandString".$similarCommands');
        }
      }
      // Step into the command.
      argResults = argResults.command!;
      // ignore: unnecessary_null_checks
      command = commands[argResults.name];
      commands = command!.subcommands;
      commandString += ' ${argResults.name}';

      if (argResults.options.contains('help') && argResults.flag('help')) {
        command.printUsage();
        return null;
      }
    }
    if (topLevelResults.command?.name == 'completion') {
      await super.runCommand(topLevelResults);
      return ExitCode.success.code;
    }

    logger.trace(
      '~ run command ${topLevelResults.command?.name}',
      commandName: topLevelResults.command?.name,
    );
    return await super.runCommand(topLevelResults);
  }

  @override
  Never usageException(String message) => throw UsageException(message, publicUsageWithoutDescription);

  // Returns help text for commands similar to `name`, in sorted order.
  String _similarCommandsText<T>(String name, Iterable<args_command_runner.Command<T>> commands) {
    if (suggestionDistanceLimit <= 0) return '';
    final distances = <args_command_runner.Command<T>, int>{};
    final candidates = SplayTreeSet<args_command_runner.Command<T>>((a, b) => distances[a]! - distances[b]!);
    for (final command in commands) {
      if (command.hidden) continue;
      for (final alias in [
        command.name,
        ...command.aliases,
        ...command.suggestionAliases,
      ]) {
        final distance = _editDistance(name, alias);
        if (distance <= suggestionDistanceLimit) {
          distances[command] = math.min(distances[command] ?? distance, distance);
          candidates.add(command);
        }
      }
    }
    if (candidates.isEmpty) return '';

    final similar = StringBuffer();
    similar
      ..newLine()
      ..verticalLine()
      ..withPrefix(
        '?',
        console.theme.colors.hint('Did you mean one of these?'),
        style: console.theme.colors.hint,
      )
      ..newLine();
    final line = candidates.map((e) => e.name).join(', ');
    similar
      ..write(console.theme.prefixLine(''))
      ..write(' ')
      ..write(console.theme.colors.text(line))
      ..newLine();

    return similar.toString();
  }
}

/// Flushes the stdout and stderr streams, then exits the program with the given
/// status code.
///
/// This returns a Future that will never complete, since the program will have
/// exited already. This is useful to prevent Future chains from proceeding
/// after you've decided to exit.
Future flushThenExit(int status) {
  return Future.wait([stdout.close(), stderr.close()]).then((_) {});
}
