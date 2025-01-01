import 'package:promptly/promptly.dart' show EmailValidator, line, prompt, header, success;

void main() {
  header('Input', message: 'Please provide the following information:');
  final name = prompt('Your name');
  line();

  final email = prompt(
    'Your email',
    validator: EmailValidator(),
  );
  line();

  final planet = prompt(
    'Your planet',
    defaultValue: 'Earth',
  );
  line();

  final galaxy = prompt(
    'Your galaxy',
    initialText: 'Andromeda',
  );
  line();

  success('end', message: '$name, $email, $planet, $galaxy');
}
