part of 'command_runner.dart';

/// An abstract class that extends the `Command` class  from `args` package.
///
/// This class serves as a base for creating custom command classes that can
/// be used with the `args_command_runner` package.
///
/// Type parameter [T] specifies the type of the result produced by the command.
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
      ..header(name, message: description)
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
        ..write(
          console.theme.prefixSectionLine(
            console.theme.colors.text(' Flags ').inverse(),
          ),
        )
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
      ..writeln(console.theme.prefixRun(invocation))
      ..newLine();

    return buffer.toString();
  }

  @override
  void addSubcommand(args_command_runner.Command<T> command) {
    logger.trace('[$name][${command.name}] addSubcommand');
    super.addSubcommand(command);
  }
}

/// Extension on the `Command` class to provide convenient methods for accessing
/// argument results.
///
/// This extension includes methods to safely retrieve options, flags, and other
/// argument results from the command-line arguments passed to a `Command`.
///
/// Methods:
/// - `option(String name)`: Retrieves the value of the specified option.
/// - `options(String name)`: Returns a list of options for the given name.
/// - `flag(String name)`: Retrieves the boolean value of a flag.
/// - `rest()`: Returns the remaining command-line arguments that were not parsed as options or flags.
/// - `wasParsed(String name)`: Checks if the argument with the given name was parsed.

extension CommandX on Command {
  args.ArgResults _safeArgResults() {
    if (argResults == null) {
      throw StateError('Command has not been run yet.');
    }
    return argResults!;
  }

  /// Retrieves the value of the specified option from the argument results.
  ///
  /// This method safely accesses the argument results and returns the value
  /// associated with the given option name. If the option is not found, it
  /// returns `null`.
  ///
  /// - Parameter name: The name of the option to retrieve.
  /// - Returns: The value of the specified option, or `null` if the option is not found.
  String? option(String name) => _safeArgResults().option(name);

  /// Returns a list of options for the given [name].
  ///
  /// This method retrieves multiple options associated with the specified
  /// [name] from the argument results.
  ///
  /// - Parameter [name]: The name of the option to retrieve.
  /// - Returns: A list of strings representing the options for the given name.
  List<String> options(String name) => _safeArgResults().multiOption(name);

  /// Retrieves the boolean value of a flag from the argument results.
  ///
  /// This method fetches the value of a flag with the given [name] from the
  /// argument results. If the flag is not found, it returns `null`.
  ///
  /// [name] The name of the flag to retrieve.
  ///
  /// Returns a boolean value indicating the state of the flag, or `null` if the
  /// flag is not present.
  bool? flag(String name) => _safeArgResults().flag(name);

  /// Returns the remaining command-line arguments that were not parsed as options or flags.
  ///
  /// This method retrieves the list of arguments that were not recognized as options or flags
  /// from the argument results.
  ///
  /// Returns:
  ///   A list of strings representing the remaining unparsed arguments.
  List<String> rest() => _safeArgResults().rest;

  /// Checks if the argument with the given [name] was parsed.
  ///
  /// Returns `true` if the argument was parsed, otherwise `false`.
  ///
  /// [name] - The name of the argument to check.
  bool wasParsed(String name) => _safeArgResults().wasParsed(name);
}
