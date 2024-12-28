import 'dart:io' show stdout;

import 'package:zoo_console/zoo_console.dart' show Password;

void main() {
  final password = Password(
    prompt: 'Password',
    confirmation: true,
    confirmPrompt: 'Repeat password',
  ).interact();
  stdout.writeln(password);
}
