import 'package:zoo_console/zoo_console.dart';

void main() {
  start('Link', message: 'This is a link example');
  final www = link((uri: Uri.parse('https://dart.dev'), message: 'The Dart Website'));
  console.end('Website', message: 'open $www!');
}
