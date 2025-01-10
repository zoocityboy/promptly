// ignore_for_file: use_string_buffers

import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math' as math;

import 'package:args/args.dart' as args;
import 'package:args/command_runner.dart' as args_command_runner;
import 'package:cli_completion/cli_completion.dart' as completion;
import 'package:path/path.dart' as p;
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
      ..section(console.theme.colors.text(' $title ').inverse())
      ..newLine();
  }
  final columnStart = length + 4;
  for (final category in categories) {
    if (category.isNotEmpty) {
      buffer
        ..section(console.theme.colors.text(' $category ').inverse())
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

/// Returns the edit distance between `from` and `to`.
//
/// Allows for edits, deletes, substitutions, and swaps all as single cost.
///
/// See https://en.wikipedia.org/wiki/Damerau%E2%80%93Levenshtein_distance#Optimal_string_alignment_distance
int _editDistance(String from, String to) {
  // Add a space in front to mimic indexing by 1 instead of 0.
  from = ' $from';
  to = ' $to';
  final distances = [
    for (var i = 0; i < from.length; i++)
      [
        for (var j = 0; j < to.length; j++)
          if (i == 0) j else if (j == 0) i else 0,
      ],
  ];

  for (var i = 1; i < from.length; i++) {
    for (var j = 1; j < to.length; j++) {
      // Removals from `from`.
      var min = distances[i - 1][j] + 1;
      // Additions to `from`.
      min = math.min(min, distances[i][j - 1] + 1);
      // Substitutions (and equality).
      min = math.min(
        min,
        distances[i - 1][j - 1] +
            // Cost is zero if substitution was not actually necessary.
            (from[i] == to[j] ? 0 : 1),
      );
      // Allows for basic swaps, but no additional edits of swapped regions.
      if (i > 1 && j > 1 && from[i] == to[j - 1] && from[i - 1] == to[j]) {
        min = math.min(min, distances[i - 2][j - 2] + 1);
      }
      distances[i][j] = min;
    }
  }

  return distances.last.last;
}
