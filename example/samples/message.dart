import 'package:promptly/promptly.dart';

void main() {
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

  message('Verbose This is a message', style: MessageStyle.verbose);
  message(
    '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae.
Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia.
Curabitur non nulla sit amet nisl tempus convallis quis ac lectus. Donec sollicitudin.
Mauris blandit aliquet elit, eget tincidunt nibh pulvinar a. Nulla quis lorem ut.
Nam at tortor in tellus interdum sagittis. Suspendisse potenti. Sed lectus. Integer.''',
    style: MessageStyle.verbose,
  );
  line();

  final githubLink = link('https://github.com', label: 'GitHub');
  final promptlyLink =
      link('https://github.com/zoocityboy/promptly', label: 'promptly');

  finishSuccesfuly(
    'This is a success message',
    message: 'visit $promptlyLink repository on $githubLink',
  );
}
