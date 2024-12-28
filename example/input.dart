import 'dart:io' show stdout;

import 'package:zoo_console/zoo_console.dart' show Input, ValidationError;

void main() {
  final name = Input(prompt: 'Your name').interact();
  stdout.writeln(name);

  final email = Input(
    prompt: 'Your email',
    validator: (String x) {
      if (x.contains('@')) {
        return true;
      } else {
        throw ValidationError('Not a valid email');
      }
    },
  ).interact();
  stdout.writeln(email);

  final planet = Input(
    prompt: 'Your planet',
    defaultValue: 'Earth',
  ).interact();
  stdout.writeln(planet);

  final galaxy = Input(
    prompt: 'Your galaxy',
    initialText: 'Andromeda',
  ).interact();
  stdout.writeln(galaxy);
}
