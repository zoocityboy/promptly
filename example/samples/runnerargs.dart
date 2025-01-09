import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart' as argscr;
import 'package:io/io.dart';
import 'package:promptly/promptly.dart';
import 'package:promptly/src/command/global.dart';

class MyRunner extends argscr.CommandRunner<int> {
  MyRunner(super.executableName, super.description) {
    GlobalArgs(argParser).addLogLevel();
    addCommand(TestCommand());
    addCommand(SecondCommand());
    addCommand(ThirdCommand());
  }
}

Future<void> main(List<String> args) async {
  final runner = MyRunner(
    'promptly',
    'Runner test',
  );
  await runner.run(args);
}

class TestCommand extends argscr.Command<int> {
  TestCommand();

  @override
  String get name => 'test';
  @override
  String get description => 'Test command';
  @override
  String get category => 'basic';
  @override
  Future<int> run() async {
    stdout.writeln('Running test command');
    stdout.writeln('Hello world');
    stdout.writeln('Downloading started');

    return 0;
  }
}

class SecondCommand extends argscr.Command<int> {
  @override
  String get name => 'second';
  @override
  String get description => 'Second command';
  SecondCommand() {
    argParser.addOption(
      'customName',
      help: 'Name of the person',
      mandatory: true,
    );
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

class ThirdCommand extends argscr.Command<int> {
  @override
  String get name => 'third';
  @override
  String get description => 'Third command';
  ThirdCommand() {
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

class FourthCommand extends argscr.Command<int> {
  @override
  String get name => 'fourth';
  @override
  String get description => 'Manage people';
  FourthCommand() {
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
