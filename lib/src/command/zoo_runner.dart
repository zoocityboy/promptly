import 'dart:collection';
import 'dart:math' as math;

import 'package:args/command_runner.dart';
import 'package:zoo_console/src/command/global.dart';
import 'package:zoo_console/src/theme/theme.dart';
import 'package:zoo_console/zoo_console.dart';

class ZooRunner extends CommandRunner<int> {
  ZooRunner(
    String executableName,
    String description, {
    required this.version,
  }) : super(executableName, appDescription(executableName, version, description)) {
    ZooConsole();
    ZooLogger(printer: (level, message) => ZooConsole.instance.writeln(message));
    GlobalArgs(argParser)
      ..addDebugFlag()
      ..addVerboseFlag();
  }
  final String version;

  static ZooConsole get console => ZooConsole.instance;
  static ZooLogger get logger => ZooLogger.instance;
  static String appDescription(String executableName, String cliPackageVersion, String description) {
    final StringBuffer buffer = StringBuffer();
    buffer.write(console.prefixStartStyled);
    buffer.write(' $executableName '.onGreen().white());
    buffer.write(' ');
    buffer.write('v$cliPackageVersion'.green().bold());
    buffer.write(console.theme.hintStyle(' • '));
    buffer.write(console.theme.hintStyle(description));
    buffer.write('\n${console.prefixVerticalStyled}');
    return buffer.toString();
  }

  @override
  Future<int?> run(Iterable<String> args) {
    console.clear();
    final p = parse(args);
    p.flag('debug') ? logger.level = ZooLogLevel.verbose : logger.level = ZooLogLevel.error;
    return super.run(args);
  }

  @override
  String get usage => usagex;

  @override
  void printUsage() => console.write(usage);

  /// Throws a [UsageException] with [message].
  @override
  Never usageException(String message) => throw UsageException(message, usageWithoutDescription);
}

extension CommandRunnerX on CommandRunner {
  static ZooConsole get console => ZooConsole.instance;
  String _wrap(String text, {int? hangingIndent}) =>
      wrapText(text, length: argParser.usageLineLength, hangingIndent: hangingIndent);

  String get usageWithoutDescription {
    final usagePrefix = console.theme.hintStyle('Usage:');
    final buffer = StringBuffer();

    buffer.writeLine(
      '${console.prefixVerticalStyled}$usagePrefix ${_wrap(invocation.green(), hangingIndent: usagePrefix.length)}',
    );
    buffer.writeln(console.prefixVerticalStyled);
    buffer.write(console.prefixUsageStyled);
    buffer.writeln(_wrap('Global options:'.green()));

    argParser.usage.split('\n').forEach((line) {
      buffer.write(console.prefixVerticalStyled);
      buffer.write(' ');
      buffer.writeln(console.theme.hintStyle(line));
    });
    buffer.write("${console.prefixVerticalStyled} \n");

    // buffer.writeln('${argParser.usage}\n');
    buffer.write(
      '${getZooCommandUsage(commands, lineLength: argParser.usageLineLength)}\n',
    );
    final runMessage = 'Run "$executableName help <command>" for more information about a '
        'command.';
    buffer.writeLine(console.prefixVerticalStyled);
    buffer.write(console.prefixVerticalStyled);
    buffer.write(_wrap(console.theme.hintStyle(runMessage)));
    if (usageFooter != null) {
      buffer.writeLine(console.prefixVerticalStyled);
      buffer.write(_wrap(usageFooter ?? ''.gray()));
    }
    buffer.writeln();
    buffer.writeln();
    // buffer.writeln(console.prefixUsageStyled);

    return buffer.toString();
  }

  String get usagex => _wrap('$description\n') + usageWithoutDescription;
}

extension CommandX on Command {
  ZooConsole get console => ZooConsole();
  Theme get theme => console.theme;
  int get spacing => console.spacing;
  String _wrap(String text, {int? hangingIndent}) {
    return wrapText(text, length: argParser.usageLineLength, hangingIndent: hangingIndent);
  }

  String get descriptionStyled {
    final sb = StringBuffer();
    sb.write(theme.linePrefixStyle('┌'));
    sb.write(' $name '.onGreen().white());
    sb.write(' ');
    sb.write(theme.hintStyle(description));

    return _wrap(sb.toString());
  }

  String get usageStyled => _wrap(descriptionStyled) + usageWithoutDescriptionStyled;

  String get usageWithoutDescriptionStyled {
    final length = argParser.usageLineLength;
    const usagePrefix = 'Usage: ';
    final lines = argParser.usage.split('\n').toList();
    final buffer = StringBuffer()
      ..writeLine(console.prefixVerticalStyled)
      ..writeLine('${console.prefixVerticalStyled}$usagePrefix${_wrap(
        invocation.green(),
        hangingIndent: usagePrefix.length,
      )}');

    for (final line in lines) {
      buffer.write(console.prefixVerticalStyled);
      buffer.writeLine(line);
    }

    if (subcommands.isNotEmpty) {
      buffer.write(console.prefixVerticalStyled);
      buffer.writeln();
      buffer.writeln(
        getZooCommandUsage(
          subcommands,
          isSubcommand: true,
          lineLength: length,
        ),
      );
    }

    buffer.writeLine(console.prefixVerticalStyled);
    buffer.write(
      _wrap(
        theme.hintStyle('${console.prefixVerticalStyled}Run "${runner!.executableName} help" to see global options.'),
      ),
    );

    if (usageFooter != null) {
      buffer.writeLine(console.prefixVerticalStyled);
      buffer.write(_wrap(usageFooter!));
    }

    return buffer.toString();
  }
}

/// Returns a string representation of [commands] fit for use in a usage string.
///
/// [isSubcommand] indicates whether the commands should be called "commands" or
/// "subcommands".
String getZooCommandUsage(Map<String, Command> commands, {bool isSubcommand = false, int? lineLength}) {
  final ZooConsole console = ZooConsole();
  // Don't include aliases.
  var names = commands.keys.where((name) => !commands[name]!.aliases.contains(name));

  // Filter out hidden ones, unless they are all hidden.
  final visible = names.where((name) => !commands[name]!.hidden);
  if (visible.isNotEmpty) names = visible;

  // Show the commands alphabetically.
  names = names.toList()..sort();

  // Group the commands by category.
  final commandsByCategory = SplayTreeMap<String, List<Command>>();
  for (final name in names) {
    final category = commands[name]!.category;
    commandsByCategory.putIfAbsent(category, () => []).add(commands[name]!);
  }
  final categories = commandsByCategory.keys.toList();

  final length = names.map((name) => name.length).reduce(math.max);
  final title = '${isSubcommand ? "Subc" : "C"}ommands:';
  final buffer = StringBuffer();
  buffer.write(console.prefixUsageStyled);
  buffer.write(title.green());
  buffer.write('\n');
  buffer.write(console.prefixVerticalStyled);
  final columnStart = length + 5;
  for (final category in categories) {
    if (category != '') {
      buffer.writeln();
      buffer.write(console.prefixVerticalStyled);
      buffer.write(category.darkGray());
    }
    for (final command in commandsByCategory[category]!) {
      final lines = wrapTextAsLines(command.summary, start: columnStart, length: lineLength);
      buffer.writeln();
      buffer.write(console.prefixVerticalStyled);
      buffer.write('  ${command.name.white().padLeft(length)}  ${console.theme.hintStyle(lines.first)}');

      for (final line in lines.skip(1)) {
        buffer.write(console.prefixVerticalStyled);
        buffer.write(' ' * columnStart);
        buffer.write(line);
      }
    }
    buffer.write('\n');
    buffer.write(console.prefixVerticalStyled);
  }

  return buffer.toString();
}
