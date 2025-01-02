part of 'command_runner.dart';

abstract class Command<T> extends cr.OriginalCommand<T> {
  Command(
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

  Console get console => get<Console>();

  @override
  String get invocation {
    final parents = [name];
    for (var command = parent; command != null; command = command.parent) {
      parents.add(command.name);
    }
    parents.add(runner!.executableName);

    final invocation = parents.reversed.join(' ');
    return subcommands.isNotEmpty
        ? '${theme.colors.active(invocation)} ${theme.colors.active('[subcommand]').dim()} ${theme.colors.hint('[...flags]')}'
        : '${theme.colors.active(invocation)} ${theme.colors.hint('[...flags]')}';
  }

  String _wrap(String text, {int? hangingIndent}) {
    return wrapText(text, length: argParser.usageLineLength, hangingIndent: hangingIndent);
  }

  @override
  String get usage => _wrap(descriptionStyled) + usageWithoutDescription;

  @override
  void printUsage() {
    get<Logger>().info('[$name] printUsage', delayed: true);
    console.write(usage);
  }

  Theme get theme => console.theme;
  String get descriptionStyled {
    final sb = StringBuffer();
    sb.write(console.header(name, message: description));
    sb.write(' ');
    sb.writeln(theme.colors.hint(description));
    sb.verticalLine();

    return sb.toString();
  }

  @override
  String get usageWithoutDescription {
    final length = argParser.usageLineLength ?? 0;
    final usegeLines = argParser.usage.split('\n');
    // const usagePrefix = 'Usage: ';
    final buffer = StringBuffer()
      ..writeln(console.theme.prefixLine(_wrap(invocation)))
      ..verticalLine();
    if (usegeLines.isNotEmpty) {
      buffer.write(console.theme.prefixSectionLine(console.theme.colors.sectionBlock(' Flags ')));
      buffer.write('\n');
      buffer.verticalLine();
    }
    for (final line in usegeLines) {
      buffer.write(console.theme.prefixLine(''));
      buffer.writeln(console.theme.colors.hint(line));
    }

    if (subcommands.isNotEmpty) {
      buffer.writeln();
      buffer.writeln(
        getCommandUsage(
          subcommands,
          isSubcommand: true,
          lineLength: length,
        ),
      );
    }
    if (usageFooter != null) {
      buffer.writeln();
      buffer.write(_wrap(usageFooter!));
    }

    return buffer.toString();
  }

  X get<X extends Object>() {
    return sl.get<X>();
  }
}
