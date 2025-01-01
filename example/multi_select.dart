import 'package:promptly/promptly.dart';

void main() {
  header('Multi Select', message: 'Select your favorite musicals');
  final musicals = ['Hamilton', 'Dear Evan Hansen', 'Wicked'];

  final x = multiSelect<String>(
    'Let me know your favorite musicals',
    choices: musicals,
    display: (p0) => p0,
    defaultValues: [musicals[0], musicals[2]],
  );

  if (x.isEmpty) {
    console.style("Oh, you're not a musical fan.");
  } else if (x.length == 3) {
    console.style("Omg you're such a musical fan!");
  } else {
    success(
      '${x.map((i) => i).join(' and ')} '
      '${x.length == 1 ? 'is' : 'are'} the best!',
    );
  }
}
