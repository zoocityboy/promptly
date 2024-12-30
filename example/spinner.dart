import 'package:zoo_console/src/theme/theme.dart';
import 'package:zoo_console/zoo_console.dart';

Future<void> main() async {
  final theme = Theme.zooTheme;

  final gift = processing(
    'Spinning the wheel...',
  );

  await Future.delayed(const Duration(seconds: 5));
  gift.success('Congratulations! You have won a prize!');
}
