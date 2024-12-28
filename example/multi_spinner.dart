import 'package:zoo_console/src/components/multi_spinner.dart';
import 'package:zoo_console/src/components/spinner.dart';

Future<void> main() async {
  final spinners = MultiSpinner();

  final horse = spinners.add(
    Spinner(
      prompt: 'Processing horse',
      icon: '🐴',
    ),
  );

  final rabbit = spinners.add(
    Spinner(
      prompt: 'Processing rabbit',
      icon: '🐇',
    ),
  );

  final turtle = spinners.add(
    Spinner(
      prompt: 'Processing turtle',
      icon: '🐢',
      failedIcon: '✘',
    ),
  );

  await Future.delayed(const Duration(seconds: 1));
  horse.success('Done');

  await Future.delayed(const Duration(seconds: 1));
  rabbit.failed('Failed');

  await Future.delayed(const Duration(seconds: 2));
  turtle.success('Done');
}
