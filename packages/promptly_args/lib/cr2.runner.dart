part of 'command_runner.dart';

class MyCommandRunner<T> extends CommandRunner<T> {
  MyCommandRunner(String executableName, String description, {Theme? theme})
      : theme = theme ?? Theme.make(colors: ThemeColors.defaultColors),
        super(executableName, description);

  final Theme theme;
  @override
  String get usage => _wrap('$description\n\n') + _usageWithoutDescription;

  @override
  String get _usageWithoutDescription {
    var usagePrefix = 'Usage:';
    var buffer = StringBuffer();
    buffer.writeln(
      '$usagePrefix ${_wrap(invocation, hangingIndent: usagePrefix.length)}\n',
    );
    buffer.writeln(_wrap('Global options:'));
    buffer.writeln('${argParser.usage}\n');
    buffer.writeln(
      '${_myGetCommandUsage(_commands, lineLength: argParser.usageLineLength)}\n',
    );
    buffer.write(_wrap('Run "$executableName help <command>" for more information about a '
        'command.'));
    if (usageFooter != null) {
      buffer.write('\n${_wrap(usageFooter!)}');
    }
    return buffer.toString();
  }
}

abstract class MyCommand<T> extends Command<T> {
  /// A single-line template for how to invoke this command (e.g. `"pub get
  /// `package`"`).
  @override
  String get invocation {
    var parents = [name];
    for (var command = parent; command != null; command = command.parent) {
      parents.add(command.name);
    }
    parents.add(runner!.executableName);

    var invocation = parents.reversed.join(' ');
    return _subcommands.isNotEmpty ? '$invocation <subcommand> [arguments]' : '$invocation [arguments]';
  }

  /// Returns [usage] with [description] removed from the beginning.
  @override
  String get _usageWithoutDescription {
    var length = argParser.usageLineLength;
    var usagePrefix = 'Usage: ';
    var buffer = StringBuffer()
      ..writeln(usagePrefix + _wrap(invocation, hangingIndent: usagePrefix.length))
      ..writeln(argParser.usage);

    if (_subcommands.isNotEmpty) {
      buffer.writeln();
      buffer.writeln(_myGetCommandUsage(
        _subcommands,
        isSubcommand: true,
        lineLength: length,
      ));
    }

    buffer.writeln();
    buffer.write(_wrap('Run "${runner!.executableName} help" to see global options.'));

    if (usageFooter != null) {
      buffer.writeln();
      buffer.write(_wrap(usageFooter!));
    }

    return buffer.toString();
  }
}

/// Returns a string representation of [commands] fit for use in a usage string.
///
/// [isSubcommand] indicates whether the commands should be called "commands" or
/// "subcommands".
String _myGetCommandUsage(Map<String, Command> commands, {bool isSubcommand = false, int? lineLength}) {
  // Don't include aliases.
  var names = commands.keys.where((name) => !commands[name]!.aliases.contains(name));

  // Filter out hidden ones, unless they are all hidden.
  var visible = names.where((name) => !commands[name]!.hidden);
  if (visible.isNotEmpty) names = visible;

  // Show the commands alphabetically.
  names = names.toList()..sort();

  // Group the commands by category.
  var commandsByCategory = SplayTreeMap<String, List<Command>>();
  for (var name in names) {
    var category = commands[name]!.category;
    commandsByCategory.putIfAbsent(category, () => []).add(commands[name]!);
  }
  final categories = commandsByCategory.keys.toList();

  var length = names.map((name) => name.length).reduce(math.max);

  var buffer = StringBuffer('Available ${isSubcommand ? "sub" : ""}commands:');
  var columnStart = length + 5;
  for (var category in categories) {
    if (category != '') {
      buffer.writeln();
      buffer.writeln();
      buffer.write(category);
    }
    for (var command in commandsByCategory[category]!) {
      var lines = wrapTextAsLines(command.summary, start: columnStart, length: lineLength);
      buffer.writeln();
      buffer.write('  ${padRight(command.name, length)}   ${lines.first}');

      for (var line in lines.skip(1)) {
        buffer.writeln();
        buffer.write(' ' * columnStart);
        buffer.write(line);
      }
    }
  }

  return buffer.toString();
}
