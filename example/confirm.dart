import 'package:promptly/src/console.dart';

void main() {
  header('Confirm', message: 'Please confirm the following');
  verbose('Are you sure you want to continue?');
  line();
  final x = confirm('Does it work?');
  info(x ? 'Awesome!' : 'Wait what! Check again.');
  line();
  final y = confirm(
    'Is there a default value?',
    defaultValue: true,
  );
  warning(y ? 'Wonderful!' : 'Really! This is sad.');
  line();
  final z = confirm(
    'Do you have to hit enter?',
    enterForConfirm: true,
  );
  success(z ? 'Magnificent!' : 'Ugh, Why!');
  line();

  finishSuccesfuly('done');
}
