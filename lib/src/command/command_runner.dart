// ignore_for_file: use_string_buffers

import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math' as math;

import 'package:args/args.dart' as args;
import 'package:args/command_runner.dart' as args_command_runner;
import 'package:cli_completion/cli_completion.dart' as completion;
import 'package:io/io.dart';
import 'package:meta/meta.dart';
import 'package:promptly/promptly.dart';
import 'package:promptly/src/command/global.dart';
import 'package:promptly/src/framework/framework.dart';
import 'package:promptly/src/theme/theme.dart';
import 'package:promptly/src/utils/string_buffer.dart';

export 'package:args/src/usage_exception.dart';

part 'command_runner.command.dart';
part 'command_runner.runner.dart';
part 'command_runner.usage.dart';

/// Returns a string representation of [commands] fit for use in a usage string.
///
/// [isSubcommand] indicates whether the commands should be called "commands" or
/// "subcommands".
String getStyledCommandUsage(
  Map<String, args_command_runner.Command> commands, {
  bool isSubcommand = false,
  int? lineLength,
  int helpUsageLength = 10,
}) {
  // Don't include aliases.
  var names = commands.keys.where((name) => !commands[name]!.aliases.contains(name));
  var maxLength = 0;
  for (final command in commands.values) {
    if (!command.hidden) {
      if (command.name.length > maxLength) maxLength = command.name.length;
      command.subcommands.forEach((name, subcommand) {
        if (name.length > maxLength) maxLength = name.length;
      });
    }
  }

  // Filter out hidden ones, unless they are all hidden.
  final visible = names.where((name) => !commands[name]!.hidden);
  if (visible.isNotEmpty) names = visible;

  // Show the commands alphabetically.
  names = names.toList()..sort();

  // Group the commands by category.
  final commandsByCategory = SplayTreeMap<String, List<args_command_runner.Command>>();
  for (final name in names) {
    final category = commands[name]!.category;
    final cmd = commands[name];
    if (cmd != null) {
      commandsByCategory.putIfAbsent(category, () => []).add(cmd);
    }
  }
  final categories = commandsByCategory.keys.toList();
  final hasCategories = categories.every((category) => category.isNotEmpty);

  final length = math.max(
    names.map((name) => name.length).reduce(math.max),
    helpUsageLength,
  );
  final title = '${isSubcommand ? "Subc" : "C"}ommands';
  final buffer = StringBuffer();
  buffer.verticalLine();

  if (!hasCategories) {
    buffer
      ..write(
        console.theme.prefixSectionLine(console.theme.colors.text(' $title ').inverse()),
      )
      ..newLine();
  }
  final columnStart = length + 4;
  for (final category in categories) {
    if (category.isNotEmpty) {
      buffer
        ..write(
          console.theme.prefixSectionLine(
            console.theme.colors.text(' $category ').inverse(),
          ),
        )
        ..newLine();
    }
    final ansiTable = Table(
      columns: [
        Column(
          alignment: ColumnAlignment.right,
          width: length,
          style: (p0) => console.theme.colors.text(p0),
        ),
        Column(
          width: console.windowWidth - columnStart,
        ),
      ],
    );
    for (final command in commandsByCategory[category]!) {
      final lines = wrapTextAsLines(command.summary, start: columnStart, length: 80);
      ansiTable.addRow([command.name, lines.first]);
      for (final line in lines.skip(1)) {
        ansiTable.addRow(['', line]);
      }
    }
    for (final line in ansiTable.interact().split('\n')) {
      buffer
        ..write(console.theme.prefixLine(''))
        ..write(line)
        ..newLine();
    }
  }
  return buffer.toString();
}

/// Extension on `args.ArgParser` to provide custom usage information.
///
/// This extension adds the following properties:
///
/// - `customUsage`: Returns a custom usage string generated from the parser's options.
/// - `usg`: Returns a `CustomUsage` object created from the parser's options.
/// - `getPrefixLength`: Returns the calculated usage prefix length from the parser's options.
extension ArgParserExtension on args.ArgParser {
  String get customUsage {
    return generateUsage(
      options.entries.map((e) => e.value).toList(),
      lineLength: usageLineLength,
    );
  }

  CustomUsage get usg => _createUsage(
        options.entries.map((e) => e.value).toList(),
        lineLength: usageLineLength,
      );
  int get getPrefixLength => calculateUsage(options.entries.map((e) => e.value).toList());
}
