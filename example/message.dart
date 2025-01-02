import 'package:promptly/promptly.dart';
import 'package:promptly/src/console.dart';
import 'package:promptly/src/theme/theme.dart';

void main() {
  Console(theme: Theme.make(colors: ThemeColors.testColors));
  header('Messages', message: 'Showcase of message styles');
  message('Hello, World!');
  line();
  message('Verbose This is a message', style: MessageStyle.verbose);
  line();
  message('Info This is a message', style: MessageStyle.info);
  line();
  message('Warning This is a message', style: MessageStyle.warning);
  line();
  message('Error This is a message', style: MessageStyle.error);
  line();
  final githubLink = link('https://github.com', label: 'GitHub');
  final promptlyLink = link('https://github.com/zoocityboy/promptly', label: 'promptly');
  success(
    'This is a success message',
    message: 'visit $promptlyLink repository on $githubLink',
  );
}
