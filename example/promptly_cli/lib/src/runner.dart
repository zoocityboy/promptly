import 'package:promptly/promptly.dart';
import 'package:promptly_cli/src/commands/account.dart';

class PromptlyCliRunner extends CommandRunner {
  PromptlyCliRunner()
      : super('promptly_cli', 'A command-line interface for Promptly.',
            version: '0.0.1',
            theme: Theme.make(
              colors: ThemeColors.testColors,
              symbols: ThemeSymbols.defaultSymbols.copyWith(),
            )) {
    // addCommand(ExampleCommand());
    // addCommand(SampleCommand());
    addCommand(AccountCommand());
  }
}
