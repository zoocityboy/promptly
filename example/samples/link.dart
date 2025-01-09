import 'package:promptly/promptly.dart';

void main() {
  header('Link', message: 'This is a link example');
  final www = console.linkLine('https://dart.dev', label: 'The Dart Website');
  finishSuccesfuly('Website', message: 'open $www!');
}
