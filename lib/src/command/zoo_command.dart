import 'package:args/command_runner.dart';
import 'package:zoo_console/zoo_console.dart';

abstract class ZooCommand<T> extends Command<T> {
  ZooCommand(
    this._name,
    this._description, {
    List<String> aliases = const [],
    bool? hidden,
    String? category,
  })  : _aliases = aliases,
        _hidden = hidden,
        _category = category;
  final String _name;
  @override
  String get name => _name;
  final String _description;
  @override
  String get description => _description;

  final List<String> _aliases;
  @override
  List<String> get aliases => _aliases;

  final bool? _hidden;
  @override
  bool get hidden {
    if (_hidden != null) {
      return _hidden;
    }
    if (subcommands.isEmpty) return false;
    return subcommands.values.every((subcommand) => subcommand.hidden);
  }

  final String? _category;
  @override
  String get category => _category ?? '';

  @override
  Future<T> run();

  ZooConsole get console => ZooRunner.console;

  @override
  String get invocation {
    final parents = [name];
    for (var command = parent; command != null; command = command.parent) {
      parents.add(command.name);
    }
    parents.add(runner!.executableName);

    final invocation = parents.reversed.join(' ');
    return subcommands.isNotEmpty
        ? '${invocation.magenta()} <subcommand> [arguments]'
        : '${invocation.magenta()} [arguments]';
  }

  String _wrap(String text, {int? hangingIndent}) {
    return wrapText(text, length: argParser.usageLineLength, hangingIndent: hangingIndent);
  }

  @override
  String get usage => _wrap('$descriptionStyled\n\n') + usageWithoutDescriptionStyled;

  @override
  void printUsage() {
    console.write(usage);
  }

  @override
  Never usageException(String message) => throw UsageException(_wrap(message), usageWithoutDescriptionStyled);
}
