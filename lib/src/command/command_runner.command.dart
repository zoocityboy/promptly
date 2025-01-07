part of 'command_runner.dart';

abstract class Command<T> extends args_command_runner.Command<T> {
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
  void trace(String message) => logger.trace(message, commandName: name);
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
    return super.hidden;
  }

  final String? _category;
  @override
  String get category => _category ?? '';

  Console get console => _promptlyConsole;

  Logger get logger => _promptlyLogger;

  @override
  Never usageException(String message) => throw UsageException(message, publicUsageWithoutDescription);

  @override
  String get usage => descriptionStyled + publicUsageWithoutDescription;

  /// The footer to be displayed at the end of the usage.
  int get getUsagePrefixLength => argParser.getPrefixLength;

  /// A single-line template for how to invoke this command (e.g. `"pub get
  /// `package`"`).
  @override
  String get invocation {
    final parents = [name];
    for (var command = parent; command != null; command = command.parent) {
      parents.add(command.name);
    }
    parents.add(runner!.executableName);

    final invocation = parents.reversed.join(' ');
    return subcommands.isNotEmpty ? invocationSubcommandLabel(invocation) : invocationCommandLabel(invocation);
  }

  String invocationCommandLabel(String invocation) =>
      '${theme.colors.active(invocation)} ${theme.colors.hint('[...flags]')}';

  String invocationSubcommandLabel(String invocation) =>
      '${theme.colors.active(invocation)} ${theme.colors.active('[subcommand]').dim()} ${theme.colors.hint('[...flags]')}';

  @override
  void printUsage() => console.write(usage);

  Theme get theme => console.theme;

  String get descriptionStyled {
    final sb = StringBuffer()
      ..write(promptHeader(name, message: description, theme: theme, windowWidth: console.windowWidth))
      ..newLine();
    return sb.toString();
  }

  String get publicUsageWithoutDescription {
    final length = argParser.usageLineLength ?? 0;
    final usegeLines = argParser.customUsage.split('\n');
    final buffer = StringBuffer();
    if (subcommands.isNotEmpty) {
      buffer
        ..write(
          getStyledCommandUsage(
            subcommands,
            isSubcommand: true,
            lineLength: length,
            helpUsageLength: getUsagePrefixLength,
          ),
        )
        ..verticalLine();
    }

    if (usegeLines.isNotEmpty) {
      buffer
        ..write(console.theme.prefixSectionLine(console.theme.colors.sectionBlock(' Flags ')))
        ..newLine();
    }
    for (final line in usegeLines) {
      buffer
        ..write(console.theme.prefixLine(''))
        ..write(line)
        ..newLine();
    }

    if (usageFooter != null) {
      buffer
        ..writeln()
        ..write(usageFooter);
    }

    buffer
      ..verticalLine()
      ..writeln(console.theme.prefixQuestion(invocation))
      ..newLine();

    return buffer.toString();
  }

  @override
  void addSubcommand(args_command_runner.Command<T> command) {
    logger.trace('[$name][${command.name}] addSubcommand');
    super.addSubcommand(command);
  }
}
