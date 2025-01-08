import 'package:promptly/src/console.dart';

void main() {
  header('Multi Select', message: 'Select your favorite musicals');
  final musicals = ['Hamilton', 'Dear Evan Hansen', 'Wicked'];

  final x = selectAny<String>(
    'Let me know your favorite musicals',
    choices: musicals,
    display: (p0) => p0,
    defaultValues: [musicals[0], musicals[2]],
  );
  if (x.isEmpty) {
    verbose("Oh, you're not a musical fan.");
  } else if (x.length == 3) {
    verbose("Omg you're such a musical fan!");
  } else {
    finishSuccesfuly(
      '${x.map((i) => i).join(' and ')} '
      '${x.length == 1 ? 'is' : 'are'} the best!',
    );
  }
}
