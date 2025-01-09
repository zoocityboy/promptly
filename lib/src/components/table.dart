import 'package:cli_table/cli_table.dart' as cli_table;
import 'package:meta/meta.dart';
import 'package:promptly/promptly.dart';
import 'package:promptly/src/framework/framework.dart';
import 'package:promptly/src/theme/theme.dart';

/// Enum representing the alignment options for columns in a table.
///
/// The available alignment options are:
///
/// - `left`: Aligns the content to the left.
/// - `right`: Aligns the content to the right.
/// - `center`: Centers the content.
enum ColumnAlignment { left, right, center }

/// A class representing a table component that extends [TypeComponent] with a type of [String].
///
/// The [Table] class allows you to create a table with customizable columns and rows. It supports
/// adding rows, rendering the table, and formatting the table output.
///
/// The table can be created with a default theme or a custom theme.
///
/// Example usage:
///
/// ```dart
/// final table = Table(
///   columns: [
///     Column(name: 'Name', alignment: ColumnAlignment.left),
///     Column(name: 'Age', alignment: ColumnAlignment.right),
///   ],
/// );
///
/// table.addRow(['Alice', '30']);
/// table.addRow(['Bob', '25']);
///
/// table.render();
/// ```
///
/// The table can also be created with a custom theme:
///
/// ```dart
/// final customTheme = Theme(...);
/// final table = Table.withTheme(
///   columns: [
///     Column(name: 'Name', alignment: ColumnAlignment.left),
///     Column(name: 'Age', alignment: ColumnAlignment.right),
///   ],
///   theme: customTheme,
/// );
/// ```
///
/// Properties:
/// - `columnPadding`: Padding between columns (default is 2).
/// - `_columns`: List of columns in the table.
/// - `_rows`: List of rows, each row is a list of strings.
/// - `_theme`: Theme used for styling the table.
///
/// Methods:
/// - `addRow(List<String> values)`: Adds a row to the table. The number of values must match the number of columns.
/// - `render({Context? context})`: Renders the table to the given context or the default context.
/// - `interact()`: Returns the formatted table as a string.
class Table extends TypeComponent<String> {
  final Theme _theme;

  /// List of rows, each row is a list of strings
  final List<List<String>> _rows = [];
  final List<Column> _columns;

  /// Padding between columns
  final int columnPadding;

  Table({
    this.columnPadding = 0,
    required List<Column> columns,
  })  : _columns = columns,
        _theme = Theme.defaultTheme;
  Table.withTheme({
    this.columnPadding = 0,
    required List<Column> columns,
    required Theme theme,
  })  : _columns = columns,
        _theme = theme;

  /// Add a row to the table
  void addRow(List<String> values) {
    assert(
      values.length == _columns.length,
      'Number of values must match number of columns',
    );
    _rows.add(values);
  }

  void addAll(List<List<String>> rows) {
    for (final row in rows) {
      addRow(row);
    }
  }

  @override
  void render({Context? context}) {
    (context ?? Context()).writeln(_formated);
  }

  String get _formated {
    final buffer = StringBuffer();
    final table = cli_table.Table(
      truncateChar: _theme.promptTheme.hintStyle(' ').dim(),
      columnWidths: _columns.map((column) => column.width ?? 0).toList(),
      columnAlignment: [
        ..._columns.map(
          (column) => switch (column.alignment) {
            ColumnAlignment.left => cli_table.HorizontalAlign.left,
            ColumnAlignment.right => cli_table.HorizontalAlign.right,
            ColumnAlignment.center => cli_table.HorizontalAlign.center,
          },
        ),
      ],
      style: const cli_table.TableStyle(
        compact: true,
        border: [],
        header: [],
        paddingLeft: 0,
        paddingRight: 2,
      ),
      tableChars: const cli_table.TableChars(
        top: '',
        topMid: '',
        topLeft: '',
        topRight: '',
        bottom: '',
        bottomMid: '',
        bottomLeft: '',
        bottomRight: '',
        left: '',
        leftMid: '',
        mid: '',
        midMid: '',
        right: '',
        rightMid: '',
        middle: '',
      ),
    );
    final List<List<String>> styledRows = [];
    for (final row in _rows) {
      final styledRow = row.indexed.map((data) {
        final column = _columns.elementAtOrNull(data.$1) ?? const Column();
        final style = column.style ?? _theme.tableTheme.rowTextStyle;
        return style(data.$2);
      }).toList();
      styledRows.add(styledRow);
    }
    table.addAll(styledRows);
    buffer.write(table.toString());
    return buffer.toString();
  }

  @override
  String interact() => _formated;
}

@immutable
class Column {
  const Column({
    this.alignment = ColumnAlignment.left,
    this.text,
    this.width,
    this.style,
  });
  final ColumnAlignment alignment;
  final String? text;
  final int? width;
  final StyleFunction? style;
}
