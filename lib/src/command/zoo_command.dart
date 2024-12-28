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

  ZooConsole get console => ZooCommandRunner.console;
}
