import 'package:promptly/src/components/loader.dart';
import 'package:promptly/src/components/multi_spinner.dart';

Future<void> main() async {
  final spinners = MultiSpinner();

  final horse = spinners.add(
    Loader(
      prompt: 'Processing horse',
      icon: '🐴',
    ),
  );

  final rabbit = spinners.add(
    Loader(
      prompt: 'Processing rabbit',
      icon: '🐇',
    ),
  );

  final turtle = spinners.add(
    Loader(
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
