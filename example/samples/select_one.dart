import 'package:promptly/promptly.dart';
import 'package:promptly/src/console.dart';

void main() {
  header('Select', message: 'Select your favorite programming language');
  final languages = ['Rust', 'Dart', 'TypeScript'];
  final heroes = ['Iron Man', 'Captain America', 'My Dad'];

  final x = selectOne<String>(
    'Your favorite programming language',
    choices: languages,
  );
  line();
  if (x == languages.first) {
    verbose('Oh, you are not a programmer.');
  } else {
    finishSuccesfuly('Yes, you selected: ${x.bold()}');
  }
  line();
  warning('Select carefully');
  line();
  final selcted = selectOne<String>(
    'Favorite superhero',
    choices: heroes,
    display: (p0) => p0,
    defaultValue: heroes[2],
  );
  info('Yes, you selected: ${selcted.bold()}');
  line();
  line();

  // success('Superhero', message: 'selected: ${selcted.bold()}');
  finishFailed('Superhero', message: 'selected: ${selcted.bold()}');
}
