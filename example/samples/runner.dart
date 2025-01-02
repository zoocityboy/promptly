import 'package:promptly/promptly.dart';
import 'package:promptly/src/command/promptly.dart';
import 'package:promptly/src/framework/performance_tracer.dart';
import 'package:promptly/src/theme/theme.dart';

Future<void> main(List<String> args) async {
  final app = await Promptly.init<int>(
    'promptly',
    description: 'Runner test',
    version: '0.0.1',
    theme: Theme.make(colors: ThemeColors.defaultColors),
  )
    ..addCommand(TestCommand())
    ..addCommand(SecondCommand())
    ..addCommand(ThirdCommand());
  await app.run(args);
}

class TestCommand extends Command<int> {
  TestCommand() : super('test', 'Test command', category: 'Basic') {
    _span = tracer.startSpan(name: name);
  }
  late TraceSpan _span;
  PerformanceTracer get tracer => get<PerformanceTracer>();
  @override
  Future<int> run() async {
    // _span.addArguments(argResults.options, argResults);
    header(name, message: description);

    line();
    console.info('Hello world');
    line();

    final pg = console.progress('Downloading', length: 1000);
    for (var i = 0; i < 500; i++) {
      await Future.delayed(const Duration(milliseconds: 1));
      pg.increase(2);
    }
    pg.finish();

    line();
    success(name, message: 'Done');
    tracer.endSpan(_span);
    get<Logger>().flush();
    return 0;
  }
}

class SecondCommand extends Command<int> {
  SecondCommand() : super('second', 'Second command', category: 'Studio') {
    argParser.addOption('name', help: 'Name of the person');
    argParser.addOption('age', help: 'Age of the person');
  }

  @override
  Future<int> run() async {
    header(name, message: description);
    return 0;
  }
}

class ThirdCommand extends Command<int> {
  ThirdCommand() : super('third', 'Third command', category: 'Studio') {
    argParser.addOption('name', help: 'Name of the person');
    argParser.addOption('age', help: 'Age of the person');
  }

  @override
  Future<int> run() async {
    header(name, message: description);
    return 0;
  }
}
