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
    final name = argResults!['name'] as String?;
    if (name != null) {
      writeln('Hello, $name!');
    } else {
      writeln('Hello, world!');
    }
    return 0;
  }
}
