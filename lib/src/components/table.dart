import 'dart:math' as math;

import 'package:meta/meta.dart';
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
    this.columnPadding = 2,
    required List<Column> columns,
  })  : _columns = columns,
        _theme = Theme.defaultTheme;
  Table.withTheme({
    this.columnPadding = 2,
    required List<Column> columns,
    required Theme theme,
  })  : _columns = columns,
        _theme = theme;

  /// Add a row to the table
  void addRow(List<String> values) {
    assert(values.length == _columns.length, 'Number of values must match number of columns');
    _rows.add(values);
  }

  @override
  void render({Context? context}) {
    (context ?? Context()).writeln(_formated);
  }

  String get _formated {
    final buffer = StringBuffer();
    // Print header if text in all columns is not empty

    // Calculate the width of each column
    final columnWidths = List.generate(_columns.length, (index) {
      final column = _columns[index];
      if (column.width != null && column.width! > 0) {
        return column.width!;
      } else {
        return _rows.map((row) => row[index].length).reduce(math.max);
      }
    });
    if (_columns.every((column) => column.text != null && column.text!.isNotEmpty)) {
      for (var i = 0; i < _columns.length; i++) {
        final column = _columns[i];
        final width = columnWidths[i];
        final headerText = column.text!;

        String formattedHeader;
        switch (column.alignment) {
          case ColumnAlignment.left:
            formattedHeader = headerText.padRight(width);
          case ColumnAlignment.right:
            formattedHeader = headerText.padLeft(width);
          case ColumnAlignment.center:
            final padding = (width - headerText.length) ~/ 2;
            formattedHeader = headerText.padLeft(padding + headerText.length).padRight(width);
        }

        formattedHeader = (column.style ?? _theme.tableTheme.headerTextStyle)(formattedHeader);

        buffer.write(formattedHeader);
        if (i < _columns.length - 1) {
          buffer.write(' ' * columnPadding);
        }
      }
      buffer.write('\n');
    }
    // Generate the formatted table
    for (final row in _rows) {
      for (var i = 0; i < row.length; i++) {
        final column = _columns[i];
        final value = row[i];
        final width = columnWidths[i];

        String formattedValue;
        switch (column.alignment) {
          case ColumnAlignment.left:
            formattedValue = value.padRight(width);
          case ColumnAlignment.right:
            formattedValue = value.padLeft(width);
          case ColumnAlignment.center:
            final padding = (width - value.length) ~/ 2;
            formattedValue = value.padLeft(padding + value.length).padRight(width);
        }

        formattedValue = (column.style ?? _theme.tableTheme.rowTextStyle)(formattedValue);

        buffer.write(formattedValue);
        if (i < row.length - 1) {
          buffer.write(' ' * columnPadding);
        }
      }
      buffer.write('\n');
    }
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
