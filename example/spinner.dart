import 'package:zoo_console/zoo_console.dart' show Spinner, Theme;

Future<void> main() async {
  final theme = Theme.zooTheme;

  final gift = Spinner.withTheme(
    prompt: 'Spinning the wheel...',
    theme: theme,
    icon: '🏆',
  ).interact();

  await Future.delayed(const Duration(seconds: 5));
  gift.success('Congratulations! You have won a prize!');
}
