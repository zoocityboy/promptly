import 'dart:convert' show JsonEncoder;
import 'dart:io' show exit, stderr, stdout;

import 'package:promptly/promptly.dart';

void main() {
  header('npm', message: 'This utility will walk you through creating a package.json file.');

  console.writelnStyled('Press ^C at any time to quit.');

  final name = prompt(
    'package name',
    defaultValue: 'interact',
    validator: GenericValidator<String>('Contains an invalid character!', (x) => x.contains(RegExp(r'[^a-zA-Z\d]'))),
  );

  final version = prompt(
    'version',
    defaultValue: '1.0.0',
    validator:
        GenericValidator<String>('Not a valid version!', (x) => !RegExp(r'^(\d+\.)?(\d+\.)?(\*|\d+)$').hasMatch(x)),
  );

  final description = prompt(
    'description',
  );

  final entry = prompt(
    'entry point',
    defaultValue: 'index.js',
  );

  final testCommand = prompt(
    'test command',
  );

  final repo = prompt(
    'git repository',
  );

  final keywords = prompt(
    'keywords',
  );

  final license = prompt(
    'license',
    defaultValue: 'ISC',
  );

  stdout.writeln('About to write this to package.json:');

  final content = <String, dynamic>{
    'name': name,
    'version': version,
    'description': description,
    'entry': entry,
    'repository': <String, String>{
      'type': 'git',
      'url': repo,
    },
    'scripts': <String, String>{
      'test': testCommand.isNotEmpty ? testCommand : 'echo "Error: no test specified" && exit 1',
    },
    'keywords': keywords.isEmpty ? [] : keywords.split(' '),
    'license': license,
  };

  stdout.writeln();
  stdout.writeln(JsonEncoder.withIndent(''.padLeft(4)).convert(content));
  stdout.writeln();

  final ok = confirm(
    'Is this OK?',
    defaultValue: true,
    enterForConfirm: true,
  );

  if (ok) {
    stdout.writeln('Done.');
  } else {
    stderr.writeln('Aborted.');
    exit(1);
  }
}
