import 'package:zoo_console/zoo_console.dart';

void main() {
  start('Select', message: 'Select your favorite programming language');
  final languages = ['Rust', 'Dart', 'TypeScript'];
  final heroes = ['Iron Man', 'Captain America', 'My Dad'];

  final x = select<String>(
    'Your favorite programming language',
    options: languages,
    display: (p0) => p0,
  );
  newLine();
  verticalLine();
  ZooConsole.instance.info('Omg, I like $x too.');
  verticalLine();

  // stdout.writeln('Omg, I like $x too.');

  final _ = select<String>(
    'Favorite superhero',
    options: heroes,
    display: (p0) => p0,
    defaultValue: heroes[2],
  );
  newLine();
  verticalLine();
  ZooConsole.instance.info('Agreed!');
}
