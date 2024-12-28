import 'dart:io' show stdout;

import 'package:zoo_console/src/components/password.dart';

void main() {
  final password = Password(
    prompt: 'Password',
    confirmation: true,
    confirmPrompt: 'Repeat password',
  ).interact();
  stdout.writeln(password);
}
