import 'package:zoo_console/zoo_console.dart';

Future<void> main() async {
  final gift = processing(
    'Spinning the wheel...',
  );

  await Future.delayed(const Duration(seconds: 5));
  gift.success('Congratulations! You have won a prize!');
}
