import 'dart:io';

import 'package:zoo_console/zoo_console.dart';

Future<void> main(List<String> args) async {
  final runner = ZooRunner('app', 'My app', version: '0.0.1')..addCommand(TestCommand());
  Future<dynamic> flushThenExit(int? status) {
    return Future.wait<void>([stdout.close(), stderr.close()]).then<void>((_) => exit(status ?? 0));
  }

  await flushThenExit(await runner.run(args));
}

class TestCommand extends ZooCommand<int> {
  TestCommand() : super('test', 'Test command');
  @override
  Future<int> run() async {
    start(name, message: description);

    line();
    console.info('Hello world');
    line();

    final pg = console.progress('Downloading', length: 10000);
    for (var i = 0; i < 5000; i++) {
      await Future.delayed(const Duration(milliseconds: 1));
      pg.increase(2);
    }
    pg.done();

    line();
    end(name, message: 'Done');
    return exitCode;
  }
}
