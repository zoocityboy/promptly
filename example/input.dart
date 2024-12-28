import 'package:zoo_console/src/components/input.dart';
import 'package:zoo_console/zoo_console.dart' show Input, Theme, ValidationError, ZooConsole, prompt;

void main() {
  final console = ZooConsole();
  final name = console.prompt('Your name');
  console.writeln(name);

  final email = prompt(
    'Your email',
    validator: (String x) {
      if (x.contains('@')) {
        return true;
      } else {
        throw ValidationError('Not a valid email');
      }
    },
  );

  console.writeln(email);
  console.verticalLine();

  final planet = prompt(
    'Your planet',
    defaultValue: 'Earth',
  );
  console.writeln(planet);
  console.verticalLine();

  final galaxy = prompt(
    'Your galaxy',
    initialText: 'Andromeda',
  );
  console.writeln(galaxy);
  console.verticalLine();
}
