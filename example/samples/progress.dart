import 'package:promptly/promptly.dart';

Future<void> main() async {
  const length = 1000;
  // final progress = Progress.withTheme(
  //   'Downloading',
  //   theme: theme,
  //   length: length,
  // ).interact();
  final result = progress('Downloading', length: length);

  for (var i = 0; i < 500; i++) {
    await Future.delayed(const Duration(milliseconds: 5));
    result.increase(2);
  }

  result.finish('Downloaded', 'File is downloaded.');
}
