import 'dart:async';

import 'package:io/io.dart';
import 'package:promptly/promptly.dart';
import 'package:promptly/src/console.dart';
import 'package:promptly/src/theme/theme.dart';

class MyRunner extends CommandRunner {
  MyRunner(super.executableName, super.description, {super.version, super.theme, super.logLevel}) {
    addCommand(TestCommand());
    addCommand(SecondCommand());
    addCommand(ThirdCommand());
  }
}

Future<void> main(List<String> args) async {
  final runner = MyRunner(
    'promptly',
    'Runner test',
    version: '0.0.1',
    theme: Theme.defaultTheme,
  );
  await runner.run(args);
}

class TestCommand extends Command<int> {
  TestCommand()
      : super(
          'test',
          'Test command',
          category: 'Basic',
        );

  @override
  Future<int> run() async {
    trace('Running test command');
    // header(name, message: description);

    line();
    info('Hello world');
    line();
    trace('Downloading started');
    final pg = console.progress('Downloading', length: 1000);
    for (var i = 0; i < 500; i++) {
      await Future.delayed(const Duration(milliseconds: 1));
      pg.increase(2);
    }
    pg.finish();

    line();
    finishSuccesfuly(name, message: 'Done');

    logger.flush();
    return 0;
  }
}

class SecondCommand extends Command<int> {
  SecondCommand()
      : super(
          'second',
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
              'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
              'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. '
              'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. '
              'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
          // category: 'Studio',
        ) {
    argParser.addOption('customName', help: 'Name of the person', mandatory: true);
    argParser.addOption('age', help: 'Age of the person');
  }
  @override
  FutureOr<int>? run() {
    final customName = argResults?.option('customName');
    message('CustomName: $customName');

    return null;

    // usageException('message');
  }
}

class ThirdCommand extends Command<int> {
  ThirdCommand()
      : super(
          'third',
          'Third command',
          // category: 'Studio',
        ) {
    addSubcommand(FourthCommand());
    argParser
      ..addOption(
        'discrete',
        abbr: 'd',
        help: 'A discrete option with "allowed" values (mandatory)',
        allowed: ['foo', 'bar', 'faa'],
        aliases: [
          'allowed',
          'defined-values',
        ],
        allowedHelp: {
          'foo': 'foo help',
          'bar': 'bar help',
          'faa': 'faa help',
        },
        mandatory: true,
      )
      ..addSeparator('yay')
      ..addOption(
        'hidden',
        hide: true,
        help: 'A hidden option',
      )
      ..addOption(
        'continuous', // intentionally, this one does not have an abbr
        help: 'A continuous option: any value is allowed',
      )
      ..addOption(
        'no-option',
        help: 'An option that starts with "no" just to make confusion '
            'with negated flags',
      )
      ..addMultiOption(
        'multi-d',
        abbr: 'm',
        allowed: [
          'fii',
          'bar',
          'fee',
          'i have space', // arg parser wont accept space on "allowed" values,
          // therefore this should never appear on completions
        ],
        allowedHelp: {
          'fii': 'fii help',
          'bar': 'bar help',
          'fee': 'fee help',
          'i have space': 'an allowed option with space on it',
        },
        help: 'An discrete option that can be passed multiple times ',
      )
      ..addMultiOption(
        'multi-c',
        abbr: 'n',
        help: 'An continuous option that can be passed multiple times',
        defaultsTo: ['default'],
      )
      ..addFlag(
        'hiddenflag',
        hide: true,
        help: 'A hidden flag',
      )
      ..addFlag(
        'flag',
        abbr: 'f',
        aliases: ['itIsAFlag'],
      )
      ..addFlag(
        'inverseflag',
        abbr: 'i',
        defaultsTo: true,
        help: 'A flag that the default value is true',
      )
      ..addFlag(
        'trueflag',
        abbr: 't',
        help: 'A flag that cannot be negated',
        negatable: false,
      );
  }

  @override
  Future<int> run() async {
    header(name, message: description);
    return ExitCode.success.code;
  }
}

class FourthCommand extends Command<int> {
  FourthCommand()
      : super(
          'fourth',
          'Manage people',
          // category: 'Studio',
        ) {
    argParser.addOption('name', help: 'Name of the person');
    argParser.addOption('age', help: 'Age of the person');
    argParser
      ..addMultiOption(
        'multi-d',
        abbr: 'm',
        allowed: [
          'fii',
          'bar',
          'fee',
          'i have space', // arg parser wont accept space on "allowed" values,
          // therefore this should never appear on completions
        ],
        allowedHelp: {
          'fii': 'fii help',
          'bar': 'bar help',
          'fee': 'fee help',
          'i have space': 'an allowed option with space on it',
        },
        help: 'An discrete option that can be passed multiple times ',
      )
      ..addMultiOption(
        'multi-c',
        abbr: 'n',
        help: 'An continuous option that can be passed multiple times',
        defaultsTo: ['default'],
      )
      ..addFlag(
        'hiddenflag',
        hide: true,
        help: 'A hidden flag',
      )
      ..addFlag(
        'flag',
        abbr: 'f',
        aliases: ['itIsAFlag'],
      )
      ..addFlag(
        'inverseflag',
        abbr: 'i',
        defaultsTo: true,
        help: 'A flag that the default value is true',
      )
      ..addFlag(
        'trueflag',
        abbr: 't',
        help: 'A flag that cannot be negated',
        negatable: false,
      );
  }

  @override
  Future<int> run() async {
    // header(name, message: description);
    throw UnimplementedError('Not implemented');
  }
}
