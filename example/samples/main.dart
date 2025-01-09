import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:promptly/promptly.dart';

void main() {
  header(
    'Examples',
    message: 'This is a list of all the examples available in this package.',
  );
  line();
  verbose(
    [
      'All the examples are available in their specific files in this directory!',
      'For example, run `dart example/select.dart` to see an example of a Select component.',
      ' ',
      '- zoocityboy',
      ' ',
    ].join('\n'),
  );
  line();
  info('Run in folder `example` ${Directory.current.path}');
  line();
  final files = Directory.current
      .listSync()
      .whereType<File>()
      .where((e) => e.path.endsWith('.dart'))
      .toList();
  for (final file in files) {
    final name = path.basename(file.path).replaceAll('.dart', '');

    final command = 'dart example/$name.dart';
    final label = name.pascalCase;
    final linkText = link(command, label: label);

    verbose('Run $linkText to see the $label example.');
  }
}
