part of 'command_runner.dart';

/// Generates a string of usage (i.e. help) text for a list of options.
///
/// Internally, it works like a tabular printer. The output is divided into
/// three horizontal columns, like so:
///
///     -h, --help  Prints the usage information
///     |  |        |                                 |
///
/// It builds the usage text up one column at a time and handles padding with
/// spaces and wrapping to the next line to keep the cells correctly lined up.
///
/// [lineLength] specifies the horizontal character position at which the help
/// text is wrapped. Help that extends past this column will be wrapped at the
/// nearest whitespace (or truncated if there is no available whitespace). If
/// `null` there will not be any wrapping.
String generateUsage(List optionsAndSeparators, {int? lineLength}) =>
    _createUsage(optionsAndSeparators, lineLength: lineLength).generate();

/// Calculates the usage based on the provided options and separators.
///
/// This function takes a list of options and separators, processes them,
/// and returns the width of the title column in the usage output.
///
/// - Parameter optionsAndSeparators: A list containing options and separators.
/// - Returns: An integer representing the width of the title column.
int calculateUsage(List optionsAndSeparators) => _createUsage(optionsAndSeparators).titleColumnWidth;

/// Creates a [CustomUsage] instance with the provided options and separators.
///
/// The [optionsAndSeparators] parameter is a list of options and separators
/// that will be used to create the [CustomUsage] instance.
///
/// The optional [lineLength] parameter specifies the maximum length of a line
/// in the usage output. If not provided, the default line length will be used.
///
/// Returns a [CustomUsage] instance configured with the provided options and
/// separators.
///
/// Example:
/// ```dart
/// var usage = _createUsage([option1, option2], lineLength: 80);
/// ```
CustomUsage _createUsage(List optionsAndSeparators, {int? lineLength}) => CustomUsage(optionsAndSeparators, lineLength);

/// A class that provides custom usage information for command-line applications.
///
/// This class can be used to define and display custom usage messages for
/// command-line applications, helping users understand how to use the commands
/// and options available in the application.

class CustomUsage {
  /// A list of the [Option]s intermingled with [String] separators.
  final List _optionsAndSeparators;

  /// The working buffer for the generated usage text.
  final _buffer = StringBuffer();

  /// The width in characters of each column.
  late final titleColumnWidth = _calculateTitleCoumnWidth();

  /// The horizontal character position at which help text is wrapped.
  ///
  /// Help that extends past this column will be wrapped at the nearest
  /// whitespace (or truncated if there is no available whitespace).
  final int? lineLength;

  CustomUsage(
    this._optionsAndSeparators,
    this.lineLength,
  );
  List<MapEntry<String, String>> rows = [];

  /// Generates a string displaying usage information for the defined options.
  /// This is basically the help text shown on the command line.
  String generate() {
    final max = calculate();
    for (final optionOrSeparator in _optionsAndSeparators) {
      if (optionOrSeparator is String) {
        // _writeSeparator(optionOrSeparator);
        continue;
      }
      final option = optionOrSeparator as args.Option;
      if (option.hide) continue;
      _writeRow(option, max);
    }
    final tbl = Table.withTheme(
      columns: [
        Column(
          alignment: ColumnAlignment.right,
          width: titleColumnWidth,
          style: (p0) => console.theme.colors.text(p0),
        ),
      ],
      theme: console.theme,
    );
    tbl.addAll(rows.map((e) => [e.key, e.value]).toList());
    _buffer.write(tbl.interact());
    return _buffer.toString();
  }

  int calculate() {
    return getPrefixLength + console.theme.spacing + 2;
  }

  int getTitleLength(args.Option option) {
    return '${_abbreviation(option)}${_longOption(option)}${_mandatoryOption(option)}'.removeAnsi().length;
  }

  void _writeRow(args.Option option, int max) {
    // Write the abbreviation and long option.
    final command = StringBuffer(
      '${_abbreviation(option)}${_longOption(option)}${_mandatoryOption(option)}',
    );
    final help = StringBuffer();

    if (option.help != null) {
      help.write(option.help);
    }

    // Write the allowed values.
    if (option.allowedHelp != null) {
      final allowedNames = option.allowedHelp!.keys.toList();
      allowedNames.sort();
      // _newline();
      for (final name in allowedNames) {
        command
          ..write('\n')
          ..write(_allowedTitle(option, name));
        help
          ..write('\n')
          ..write(option.allowedHelp![name] ?? ' ');
      }
      // _newline();
    } else if (option.allowed != null) {
      help
        ..write('\n')
        ..write(_buildAllowedList(option));
    } else if (option.isFlag) {
      if (option.defaultsTo == true) {
        help
          ..write('\n')
          ..write('(defaults to on)');
      }
    } else if (option.isMultiple) {
      if (option.defaultsTo != null && (option.defaultsTo as Iterable).isNotEmpty) {
        final defaults = (option.defaultsTo as List).map((value) => '"$value"').join(', ');
        help
          ..write('\n')
          ..write('(defaults to $defaults)');
      }
    } else if (option.defaultsTo != null) {
      help
        ..write('\n')
        ..write('(defaults to "${option.defaultsTo}');
    }
    rows.add(MapEntry(command.toString(), help.toString()));
  }

  int get getPrefixLength => _calculateTitleCoumnWidth();

  String _abbreviation(args.Option option) => option.abbr == null ? '' : '-${option.abbr}, ';

  String _longOption(args.Option option) {
    String result;
    if (option.negatable!) {
      result = '--[no-]${option.name}';
    } else {
      result = '--${option.name}';
    }

    if (option.valueHelp != null) result += '=<${option.valueHelp}>';

    return result;
  }

  String _mandatoryOption(args.Option option) {
    return option.mandatory ? ' (mandatory)' : '';
  }

  String _allowedTitle(args.Option option, String allowed) {
    final isDefault =
        option.defaultsTo is List ? (option.defaultsTo as List).contains(allowed) : option.defaultsTo == allowed;
    return '[$allowed]${isDefault ? ' (default)' : ''}';
  }

  int _calculateTitleCoumnWidth() {
    var max = 0;
    for (final option in _optionsAndSeparators) {
      if (option is! args.Option) continue;
      if (option.hide) continue;

      // Make room for the option.
      max = math.max(
        max,
        _abbreviation(option).length + _longOption(option).length + _mandatoryOption(option).length,
      );

      // Make room for the allowed help.
      if (option.allowedHelp != null) {
        for (final allowed in option.allowedHelp!.keys) {
          max = math.max(max, _allowedTitle(option, allowed).removeAnsi().length);
        }
      }
    }

    return max + 4;
  }

  String _buildAllowedList(args.Option option) {
    final isDefault =
        option.defaultsTo is List ? (option.defaultsTo as List).contains : (String value) => value == option.defaultsTo;

    final allowedBuffer = StringBuffer();
    allowedBuffer.write('[');
    var first = true;
    for (final allowed in option.allowed!) {
      if (!first) allowedBuffer.write(', ');
      allowedBuffer.write(allowed);
      if (isDefault(allowed)) {
        allowedBuffer.write(' (default)');
      }
      first = false;
    }
    allowedBuffer.write(']');
    return allowedBuffer.toString();
  }
}
