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
class CommandRunner<T> extends cr.OriginalCommandRunner<T> {
  CommandRunner(
    super.executableName,
    super.description, {
    required this.version,
    Theme? theme,
  }) {
    Console(theme: theme);
    Logger(printer: (level, message) => Console.instance.writeln(message));
    GlobalArgs(argParser)
      ..addDebugFlag()
      ..addVerboseFlag();
  }
  final String version;

  String get appDescription {
    final StringBuffer buffer = StringBuffer();
    buffer.write(console.theme.prefixHeaderLine(console.theme.colors.successBlock(' $executableName ')));
    buffer.write(' ');
    buffer.write(console.theme.colors.success('v$version'.bold()));
    buffer.write(console.theme.colors.hint(' • '));
    buffer.writeln(console.theme.colors.hint(description));
    buffer.verticalLine();
    return buffer.toString();
  }

  @override
  Future<T?> run(Iterable<String> args) {
    final logger = sl.get<Logger>();
    console.clear();
    final p = parse(args);
    p.flag('debug') ? logger.level = LogLevel.verbose : logger.level = LogLevel.error;
    return super.run(args);
  }

  @override
  // String get invocation => console.theme.colors.active(super.invocation);
  String get invocation =>
      '${console.theme.colors.active(executableName)} ${console.theme.colors.active('[command]').dim()} ${console.theme.colors.hint('[...flags]')}';

  @override
  String get usage => wrap(appDescription) + usageWithoutDescription;

  @override
  String get usageWithoutDescription {
    final buffer = StringBuffer();
    buffer
      ..writeln(console.theme.prefixLine(wrap(invocation)))
      ..verticalLine();
    buffer.write(
      getCommandUsage(commands, lineLength: argParser.usageLineLength),
    );
    buffer
      ..verticalLine()
      ..writeln(console.theme.prefixLine(console.theme.colors.sectionBlock(wrap(' Flags '))))
      ..verticalLine();
    for (final line in argParser.usage.split('\n')) {
      buffer
        ..write(console.theme.prefixLine(''))
        ..writeln(console.theme.colors.hint(line));
    }

    if (usageFooter != null) {
      buffer.write('\n${wrap(usageFooter!)}');
    }
    return buffer.toString();
  }

  X get<X extends Object>() {
    stdout.writeln('get<$X>:  ${sl.hashCode}');
    return sl.get<X>();
  }
}
