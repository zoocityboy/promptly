import 'package:promptly/promptly.dart';

void main() {
  header('Select', message: 'Select your favorite programming language');
  final languages = ['Rust', 'Dart', 'TypeScript'];
  final heroes = ['Iron Man', 'Captain America', 'My Dad'];

  final x = select<String>(
    'Your favorite programming language',
    choices: languages,
  );
  line();
  console.style('Language selected: ${x.bold().green()}', prefix: (xx) => xx.message('', style: MessageStyle.verbose));

  final _ = select<String>(
    'Favorite superhero',
    choices: heroes,
    display: (p0) => p0,
    defaultValue: heroes[2],
  );
  line();
  // ignore: no_wildcard_variable_uses
  success('Superhero', message: 'selected: ${_.bold()}');
  failure('Superhero', message: 'selected: ${_.bold()}');
}
