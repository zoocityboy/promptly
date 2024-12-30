import 'package:zoo_console/zoo_console.dart';

void main() {
  start('Password', message: 'Enter your password');
  final value = password(
    'Password',
    confirmation: true,
    confirmPrompt: 'Repeat password',
  );
  spacer();
  line();
  end('Password', message: 'Password `$value` entered');
}
