import 'dart:convert';

import 'package:dart_console/dart_console.dart' as dc;
import 'package:promptly/src/framework/framework.dart';
import 'package:promptly/src/theme/theme.dart';
import 'package:promptly/src/utils/prompt.dart';

typedef TableRow = List<Object>;

class Table extends Component<int> {
  Table(
    this.prompt, {
    required this.headers,
    required this.rows,
  }) : theme = Theme.defaultTheme;

  Table.withTheme(
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
  _TableState createState() => _TableState();
}

class _TableState extends State<Table> {
  late int index;
  int? picked;

  int tableRenderCount = 0;

  TableTheme get theme => component.theme.tableTheme;

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
        theme: component.theme,
        message: component.prompt,
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
