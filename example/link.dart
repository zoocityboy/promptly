import 'package:promptly/promptly.dart';

void main() {
  header('Link', message: 'This is a link example');
  final www = link('https://dart.dev', label: 'The Dart Website');
  console.success('Website', message: 'open $www!');
}
