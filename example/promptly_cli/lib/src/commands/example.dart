import 'package:promptly/promptly.dart';

class ExampleCommand extends Command<int> {
  ExampleCommand() : super('example', 'An example command.') {
    argParser.addOption(
      'title',
      abbr: 'n',
      help: 'The title of the person to greet.',
    );
  }

  @override
  Future<int> run() async {
    final title = option('title');
    if (title != null) {
      success('Hello, $title!');
    } else {
      warning('Hello, world!');
    }
    line();
    line();
    verbose('Verbose message');
    line();
    info('Info message');
    line();
    warning('Warning message');
    line();
    error('Error message');
    line();
    success('Success message');

    line();
    line();

    return finishSuccesfuly('Done',
        message: 'This is the end of the example command.');
  }
}
