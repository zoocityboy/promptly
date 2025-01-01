import 'package:promptly/promptly.dart';

Future<void> main() async {
  header('Spinner', message: 'Spinning the wheel...');
  final gift = processing(
    'Spinning the wheel...',
  );

  await Future.delayed(const Duration(seconds: 5));
  gift.success('Congratulations! You have won a prize!');
}
