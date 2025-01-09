import 'package:promptly/promptly.dart'
    show EmailValidator, finishSuccesfuly, header, line, prompt;
import 'package:promptly/src/validators/validator.dart';

void main() {
  header('Input', message: 'Please provide the following information:');
  final name = prompt('Your name', validator: IsNotEmptyValidator());
  line();

  final email = prompt(
    'Your email',
    validator: EmailValidator(),
  );
  line();

  final planet = prompt(
    'Your planet',
    defaultValue: 'Earth',
    validator: AllowedValidator(['Earth', 'Mars', 'Venus']),
  );
  line();

  final galaxy = prompt(
    'Your galaxy',
    initialText: 'Andromeda',
    validator: AllowedValidator(['Andromeda', 'Milky Way']),
  );
  line();

  finishSuccesfuly('end', message: '$name, $email, $planet, $galaxy');
}
