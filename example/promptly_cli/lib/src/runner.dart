import 'package:promptly/promptly.dart';

import 'commands/example.dart';
import 'commands/sample.dart';

class PromptlyCliRunner extends CommandRunner {
  PromptlyCliRunner()
      : super(
          'promptly_cli',
          'A command-line interface for Promptly.',
          version: '0.0.1',
        ) {
    addCommand(ExampleCommand());
    addCommand(SampleCommand());
  }
}
