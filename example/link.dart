import 'package:promptly/promptly.dart';

void main() {
  header('Link', message: 'This is a link example');
  final www = link((uri: Uri.parse('https://dart.dev'), message: 'The Dart Website'));
  console.success('Website', message: 'open $www!');
}
