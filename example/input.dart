import 'package:zoo_console/zoo_console.dart' show EmailValidator, end, line, prompt, start;

void main() {
  start('Input', message: 'Please provide the following information:');
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

  end('end', message: '$name, $email, $planet, $galaxy');
}
