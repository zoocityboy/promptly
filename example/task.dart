import 'package:promptly/src/console.dart';

Future<void> main() async {
  header('Async Task', message: 'Showcase of async task');
  await task(
    'Run task',
    successMessage: 'Task completed successfully',
    failedMessage: 'Task failed',
    task: (task) async {
      await Future.delayed(const Duration(seconds: 2));
    },
  );
  line();
  await task(
    'Run task',
    successMessage: 'Task completed successfully',
    failedMessage: 'Task failed',
    task: (task) async {
      await Future.delayed(const Duration(seconds: 2));
      throw Exception('Error occurred');
    },
  );

  line();

  Future.wait([
    task(
      'Task 1',
      task: (value) async {
        await Future.delayed(const Duration(seconds: 2));
      },
    ),
    task(
      'Task 2',
      task: (value) async {
        await Future.delayed(const Duration(seconds: 3));
      },
    ),
  ]);
}
