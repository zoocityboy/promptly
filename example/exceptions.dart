import 'package:promptly/promptly.dart' show processing, reset;

Future<void> main() async {
  try {
    processing(
      'throwing an exception',
      failedMessage: 'An error occurred',
    );

    await Future.delayed(const Duration(seconds: 1));
    throw Exception();
  } catch (e) {
    reset(); // Reset everything to terminal defaults
    rethrow;
  }
}
