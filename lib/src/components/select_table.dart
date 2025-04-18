import 'dart:convert';

import 'package:dart_console/dart_console.dart' as dc;
import 'package:promptly/src/framework/framework.dart';
import 'package:promptly/src/theme/theme.dart';
import 'package:promptly/src/utils/prompt.dart';

/// A type definition for a table row, which is represented as a list of objects.
///
/// Each element in the list corresponds to a cell in the table row.
typedef TableRow = List<Object>;

/// A widget that displays a table with selectable rows.
///
/// The [SelectTable] widget takes a prompt, headers, and rows to display
/// a table. It also allows for an optional theme to be specified.
///
/// There are two constructors available:
/// - [SelectTable]: Uses the default theme.
/// - [SelectTable.withTheme]: Allows specifying a custom theme.
///
/// Example usage:
/// ```dart
/// SelectTable(
///   'Select an option:',
///   headers: ['Header1', 'Header2'],
///   rows: [TableRow(children: [Text('Row1'), Text('Row2')])],
/// );
/// ```
///
/// Example usage with custom theme:
/// ```dart
/// SelectTable.withTheme(
///   'Select an option:',
///   headers: ['Header1', 'Header2'],
///   rows: [TableRow(children: [Text('Row1'), Text('Row2')])],
///   theme: customTheme,
/// );
/// ```
///
/// Properties:
/// - [theme]: The theme to be used for the table. Defaults to [Theme.defaultTheme].
/// - [headers]: A list of strings representing the headers of the table.
/// - [rows]: A list of [TableRow] representing the rows of the table.
/// - [prompt]: A string prompt to be displayed above the table.

class SelectTable extends StateComponent<int> {
  SelectTable(
    this.prompt, {
    required this.headers,
    required this.rows,
  }) : theme = Theme.defaultTheme;

  SelectTable.withTheme(
    this.prompt, {
    required this.headers,
    required this.rows,
    required this.theme,
  });

  final Theme theme;
  final List<String> headers;
  final List<TableRow> rows;
  final String prompt;

  @override
  _SelectTableState createState() => _SelectTableState();
}

class _SelectTableState extends State<SelectTable> {
  late int index;
  int? picked;

  int tableRenderCount = 0;

  SelectTableTheme get theme => component.theme.selectTableTheme;

  // create a function for render json as pretty print
  String prettyJson(Map json) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }

  @override
  void init() {
    super.init();

    if (component.rows.isEmpty) {
      throw Exception("Rows can't be empty");
    }
    index = 0;

    ///
    context.writeln(
      promptInput(
        theme: component.theme,
        message: 'Select a row:',
      ),
    );
    context.hideCursor();
  }

  @override
  void dispose() {
    context.erasePreviousLine(tableRenderCount);
    context.resetLinesCount();

    final rowItem = component.rows[index];
    final item = {};
    for (var i = 0; i < component.headers.length; i++) {
      item[component.headers[i]] = theme.headerStyle(rowItem[i].toString());
    }

    context.writeln(
      promptSuccess(
        component.prompt,
        theme: component.theme,
        value: prettyJson(item),
      ),
    );
    context.showCursor();
    super.dispose();
  }

  @override
  void render() {
    final dc.Table table = dc.Table();
    for (var i = 0; i < component.headers.length; i++) {
      table.insertColumn(header: component.headers[i]);
    }

    for (var i = 0; i < component.rows.length; i++) {
      final data = i == index
          ? component.rows[i].map((e) => theme.activeItemStyle(e.toString())).toList()
          : component.rows[i].map((e) => theme.inactiveItemStyle(e.toString())).toList();
      table.insertRow(data);
    }
    table.borderStyle = dc.BorderStyle.square;
    table.borderColor = dc.ConsoleColor.white;
    table.borderType = dc.BorderType.vertical;

    final rndr = table.render();
    tableRenderCount = rndr.split('\n').length;
    context.writeln(rndr);
  }

  @override
  int interact() {
    while (true) {
      final key = context.readKey();
      switch (key.controlChar) {
        case dc.ControlCharacter.arrowUp:
          context.erasePreviousLine(tableRenderCount);
          context.resetLinesCount();
          setState(() {
            index = (index - 1) % component.rows.length;
          });

        case dc.ControlCharacter.arrowDown:
          context.erasePreviousLine(tableRenderCount);
          context.resetLinesCount();
          setState(() {
            index = (index + 1) % component.rows.length;
          });

        case dc.ControlCharacter.enter:
          return index;
        default:
          break;
      }
    }
  }
}
