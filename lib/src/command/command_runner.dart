// ignore_for_file: use_string_buffers

import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

import 'package:promptly/promptly.dart';
import 'package:promptly/src/command/arg.dart' as cr;
import 'package:promptly/src/command/global.dart';
import 'package:promptly/src/framework/framework.dart';
import 'package:promptly/src/theme/theme.dart';
import 'package:promptly/src/utils/string_buffer.dart';

export 'package:args/src/usage_exception.dart';

part 'command_runner.command.dart';
part 'command_runner.runner.dart';

/// The built-in help command that's added to every [PromptlyRunner].
///
/// This command displays help information for the various subcommands.
class HelpCommand<T> extends Command<T> {
  HelpCommand() : super('help', 'Display help information for');
  @override
  final name = 'help';

  @override
  String get description => 'Display help information for ${runner!.executableName}.';

  @override
  String get invocation => '${runner!.executableName} help [command]';

  @override
  bool get hidden => true;

  @override
  Null run() {
    // Show the default help if no command was specified.
    if (argResults!.rest.isEmpty) {
      runner!.printUsage();
      return;
    }

    // Walk the command tree to show help for the selected command or
    // subcommand.
    var commands = runner!.commands;
    cr.OriginalCommand<T>? command;
    var commandString = runner!.executableName;

    for (final name in argResults!.rest) {
      if (commands.isEmpty) {
        command!.usageException(
          'Command "$commandString" does not expect a subcommand.',
        );
      }

      if (commands[name] == null) {
        if (command == null) {
          runner!.usageException('Could not find a command named "$name".');
        }

        command.usageException(
          'Could not find a subcommand named "$name" for "$commandString".',
        );
      }

      command = commands[name];
      commands = command!.subcommands;
      commandString += ' $name';
    }

    command!.printUsage();
    return;
  }
}

/// Returns a string representation of [commands] fit for use in a usage string.
///
/// [isSubcommand] indicates whether the commands should be called "commands" or
/// "subcommands".
String getCommandUsage(Map<String, cr.OriginalCommand> commands, {bool isSubcommand = false, int? lineLength}) {
  // Don't include aliases.
  var names = commands.keys.where((name) => !commands[name]!.aliases.contains(name));

  // Filter out hidden ones, unless they are all hidden.
  final visible = names.where((name) => !commands[name]!.hidden);
  if (visible.isNotEmpty) names = visible;

  // Show the commands alphabetically.
  names = names.toList()..sort();

  // Group the commands by category.
  final commandsByCategory = SplayTreeMap<String, List<cr.OriginalCommand>>();
  for (final name in names) {
    final category = commands[name]!.category;
    final cmd = commands[name];
    if (cmd != null) commandsByCategory.putIfAbsent(category, () => []).add(cmd);
  }
  final categories = commandsByCategory.keys.toList();

  final length = math.max(names.map((name) => name.length).reduce(math.max), 16);
  final title = '${isSubcommand ? "Subc" : "C"}ommands';
  final buffer = StringBuffer();
  if (categories.isEmpty) {
    {
      buffer.write(console.theme.prefixLine(console.theme.colors.sectionBlock(' $title ')));
      buffer.writeln();
      buffer.write(console.theme.prefixLine(''));
    }
  }
  final columnStart = length + 4;
  for (final category in categories) {
    if (category.isNotEmpty) {
      buffer.verticalLine();
      buffer.write(console.theme.prefixSectionLine(console.theme.colors.sectionBlock(' $category ')));

      buffer.write('\n');
      buffer.verticalLine();
    }
    for (final command in commandsByCategory[category]!) {
      final lines = wrapTextAsLines(command.summary, start: columnStart, length: lineLength);

      buffer.write(console.theme.prefixLine(''));
      buffer.write(
        '${console.theme.colors.active(command.name).padLeft(columnStart)}  ${console.theme.colors.hint(lines.first)}',
      );
      buffer.write('\n');

      for (final line in lines.skip(1)) {
        buffer.write('\n');
        buffer.write(console.theme.prefixLine(''));
        buffer.write(' ' * columnStart);
        buffer.write(line);
      }
      // buffer.verticalLine();
    }

    // buffer.write(console.theme.prefixLine(''));
    // buffer.write('\n');
  }
  return buffer.toString();
}
