import 'package:promptly/promptly.dart';

class ExampleCommand extends Command<int> {
  ExampleCommand() : super('example', 'An example command.') {
    argParser.addOption(
      'name',
      abbr: 'n',
      help: 'The name of the person to greet.',
    );
  }

  @override
  Future<int> run() async {
    final name = argResults!['name'] as String?;
    if (name != null) {
      writeln('Hello, $name!');
    } else {
      writeln('Hello, world!');
    }
    return 0;
  }
}
