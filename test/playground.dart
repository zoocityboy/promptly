import 'package:promptly/promptly.dart';

Future<void> main() async {
  header('Run', message: 'async operation');
  await task(
    'My task',
    task: (value) async {
      await Future.delayed(const Duration(seconds: 2));
      throw Exception('Not found');
    },
  );
  finishFailed('My task failed');
}
