import 'package:zoo_console/zoo_console.dart';

void main() {
  start('Select', message: 'Select your favorite programming language');
  final languages = ['Rust', 'Dart', 'TypeScript'];
  final heroes = ['Iron Man', 'Captain America', 'My Dad'];

  final x = select<String>(
    'Your favorite programming language',
    choices: languages,
  );
  line();
  console.style('Language selected: ${x.bold().green()}', prefix: (xx) => xx.prefixTraceStartStyled.green());

  final _ = select<String>(
    'Favorite superhero',
    choices: heroes,
    display: (p0) => p0,
    defaultValue: heroes[2],
  );
  line();
  // ignore: no_wildcard_variable_uses
  end('Superhero', message: 'selected: ${_.green().bold()}');
}
