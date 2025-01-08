import 'package:promptly/promptly.dart' show header, task;

Future<void> main() async {
  // try {
  //   processing(
  //     'throwing an exception',
  //     failedMessage: 'An error occurred',
  //   );

  //   await Future.delayed(const Duration(seconds: 1));
  //   throw Exception();
  // } catch (e) {
  //   reset(); // Reset everything to terminal defaults
  //   rethrow;
  // }
  header('Run', message: 'Running the task');

  await task(
    'How to throw',
    task: (_) async {
      throw Exception('This is an exception');
    },
  );
}
