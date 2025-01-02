import 'package:promptly/src/console.dart';

void main() {
  Console();
  header('Confirm', message: 'Please confirm the following');
  message('Are you sure you want to continue?');
  final x = confirm('Does it work?');
  line(message: x ? 'Awesome!' : 'Wait what! Check again.');

  final y = confirm(
    'Is there a default value?',
    defaultValue: true,
  );
  line(message: y ? 'Wonderful!' : 'Really! This is sad.');

  final z = confirm(
    'Do you have to hit enter?',
    enterForConfirm: true,
  );
  line(message: z ? 'Magnificent!' : 'Ugh, Why!');
}
