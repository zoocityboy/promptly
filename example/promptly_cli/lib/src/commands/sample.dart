import 'package:promptly/promptly.dart';

class SampleCommand extends Command<int> {
  SampleCommand() : super('sample', 'An sample command.') {
    argParser.addOption(
      'name',
      abbr: 'n',
      help: 'The name of the person to greet.',
    );
  }

  @override
  Future<int> run() async {
    header(name, message: description);
    line();

    final table = Table.withTheme(
      theme: console.theme,
      columns: [
        Column(width: 20, alignment: ColumnAlignment.right),
        Column(text: 'Age', alignment: ColumnAlignment.right),
      ],
    );

    ///
    table.addRow(['Alice', '30']);
    table.addRow(['Bob', '25']);

    ///
    table.render();
    return 0;
  }
}
