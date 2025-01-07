import 'package:promptly/promptly.dart';

void main() {
  header('Password', message: 'Enter your password');
  final value = password(
    'Password',
    confirmation: true,
    confirmPrompt: 'Repeat password',
  );
  spacer();
  line();
  finishSuccesfuly('Password', message: 'Password `$value` entered');
}
