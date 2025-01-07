import 'dart:math' as Math;

import 'package:promptly/src/console.dart';

class AnsiTable {
  /// Width of the first column
  final int firstColumnWidth;

  /// List of rows, each row is a list of strings
  final List<List<String>> _rows = [];

  /// Padding between columns
  final int columnPadding;

  AnsiTable({
    required this.firstColumnWidth,
    this.columnPadding = 2,
  });

  /// Add a row to the table
  void addRow(String col1, String col2) {
    _rows.add([col1, col2]);
  }

  @override
  String toString() {
    final buffer = StringBuffer();

    for (final row in _rows) {
      final col1Lines = row[0].split('\n');
      final col2Lines = row[1].split('\n');

      // Get max number of lines between both columns
      final maxLines = Math.max(col1Lines.length, col2Lines.length);

      for (var i = 0; i < maxLines; i++) {
        final col1Text = i < col1Lines.length ? col1Lines[i] : '';
        final col2Text = i < col2Lines.length ? col2Lines[i] : '';

        final paddedCol1 = i == 0
            ? console.theme.colors.text(col1Text.padLeft(firstColumnWidth))
            : console.theme.colors.hint(col1Text.padLeft(firstColumnWidth));
        final styledCol2 = console.theme.colors.hint(col2Text);
        buffer
          ..write('\n')
          ..write('$paddedCol1${' ' * columnPadding}$styledCol2');
      }
    }

    return buffer.toString();
  }
}
