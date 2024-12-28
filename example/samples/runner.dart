import 'package:zoo_console/zoo_console.dart';

Future<void> main(List<String> args) async {
  final runner = ZooCommandRunner('app', 'My app', cliPackageVersion: '0.0.1')..addCommand(TestCommand());
  await runner.run(args);
}

class TestCommand extends ZooCommand<int> {
  TestCommand() : super('test', 'Test command');
  @override
  Future<int> run() async {
    console.start(name, message: description);
    console.verticalLine();
    console.info('Hello world');
    console.verticalLine();
    console.end(name, message: 'Done');
    return 0;
  }
}
