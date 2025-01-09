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
int calculateUsage(List optionsAndSeparators) => _createUsage(optionsAndSeparators).titleColumnWidth;
CustomUsage _createUsage(List optionsAndSeparators, {int? lineLength}) => CustomUsage(optionsAndSeparators, lineLength);

class CustomUsage {
  /// Abbreviation, long name, help.
  static const _columnCount = 3;

  /// A list of the [Option]s intermingled with [String] separators.
  final List _optionsAndSeparators;

  /// The working buffer for the generated usage text.
  final _buffer = StringBuffer();

  /// The column that the "cursor" is currently on.
  ///
  /// If the next call to [write()] is not for this column, it will correctly
  /// handle advancing to the next column (and possibly the next row).
  int _currentColumn = 0;

  /// The width in characters of each column.
  late final _columnWidths = _calculateColumnWidths();
  late final titleColumnWidth = _calculateTitleCoumnWidth();

  /// How many newlines need to be rendered before the next bit of text can be
  /// written.
  ///
  /// We do this lazily so that the last bit of usage doesn't have dangling
  /// newlines. We only write newlines right *before* we write some real
  /// content.
  int _newlinesNeeded = 0;

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
        _writeSeparator(optionOrSeparator);
        continue;
      }
      final option = optionOrSeparator as args.Option;
      if (option.hide) continue;
      _writeRow(option, max);
    }
    final x = Table(
      columns: [Column(alignment: ColumnAlignment.right, width: titleColumnWidth), const Column()],
    );
    for (final row in rows) {
      x.addRow([row.key, row.value]);
    }
    _buffer.write(x.interact());
    return _buffer.toString();
  }

  int calculate() {
    return getPrefixLength;
  }

  void _writeSeparator(String separator) {
    // Ensure that there's always a blank line before a separator.
    if (_buffer.isNotEmpty) _buffer.write('\n\n');
    _buffer.write(separator);
    _newlinesNeeded = 1;
  }

  int getTitleLength(args.Option option) {
    return '${_abbreviation(option)}${_longOption(option)}${_mandatoryOption(option)}'.length;
  }

  void _writeRow(args.Option option, int max) {
    // Write the abbreviation and long option.
    final command = StringBuffer('${_abbreviation(option)}${_longOption(option)}${_mandatoryOption(option)}');
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
          ..write(option.allowedHelp![name]);
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

  int get getPrefixLength => _columnWidths[1];

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

  List<int> _calculateColumnWidths() {
    var abbr = 0;
    var title = 0;
    for (final option in _optionsAndSeparators) {
      if (option is! args.Option) continue;
      if (option.hide) continue;

      // Make room in the first column if there are abbreviations.
      abbr = math.max(abbr, _abbreviation(option).length);

      // Make room for the option.
      title = math.max(
        title,
        _abbreviation(option).length + _longOption(option).length + _mandatoryOption(option).length,
      );

      // Make room for the allowed help.
      if (option.allowedHelp != null) {
        for (final allowed in option.allowedHelp!.keys) {
          title = math.max(title, _allowedTitle(option, allowed).length);
        }
      }
    }

    // Leave a gutter between the columns.
    // title += 4;
    return [0, title];
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
          max = math.max(max, _allowedTitle(option, allowed).length);
        }
      }
    }

    return max;
  }

  void _newline() {
    _newlinesNeeded++;
    _currentColumn = 0;
  }

  void _write(int column, String text) {
    var lines = text.split('\n');
    // If we are writing the last column, word wrap it to fit.
    if (column == _columnWidths.length && lineLength != null) {
      final start = _columnWidths.take(column).reduce((start, width) => start + width);
      lines = [
        for (final line in lines) ...wrapTextAsLines(line, start: start, length: lineLength),
      ];
    }

    // Strip leading and trailing empty lines.
    while (lines.isNotEmpty && lines.first.trim() == '') {
      lines.removeAt(0);
    }
    while (lines.isNotEmpty && lines.last.trim() == '') {
      lines.removeLast();
    }

    for (final line in lines) {
      if (column == 1) {
        if (lines.indexOf(line) == 0) {
          _writeLine(column, console.theme.colors.text(line.padLeft(_columnWidths[column])));
        } else {
          _writeLine(column, console.theme.colors.hint(line.padLeft(_columnWidths[column])));
        }
      } else {
        _writeLine(column, console.theme.colors.hint(line));
      }
    }
  }

  void _writeLine(int column, String text) {
    // Write any pending newlines.
    while (_newlinesNeeded > 0) {
      _buffer.write('\n');
      _newlinesNeeded--;
    }

    // Advance until we are at the right column (which may mean wrapping around
    // to the next line.
    while (_currentColumn != column) {
      if (_currentColumn < _columnCount - 1) {
        _buffer.write(' ' * _columnWidths[_currentColumn]);
      } else {
        _buffer.write('\n');
      }
      _currentColumn = (_currentColumn + 1) % _columnCount;
    }

    if (column < _columnWidths.length) {
      // Fixed-size column, so pad it.
      _buffer.write(text);
    } else {
      // The last column, so just write it.
      _buffer.write(' $text');
    }

    // Advance to the next column.
    _currentColumn = (_currentColumn + 1) % _columnCount;

    // If we reached the last column, we need to wrap to the next line.
    if (column == _columnCount - 1) _newlinesNeeded++;
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
