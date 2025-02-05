import 'package:promptly/src/framework/framework.dart';
import 'package:promptly/src/theme/theme.dart';
import 'package:promptly/src/utils/prompt.dart';

/// A component that handles password input with optional confirmation.
///
/// The [Password] component allows users to input a password, with an option
/// to confirm the password by entering it again. It supports theming and
/// customizable prompts and error messages.
///
/// There are two constructors available:
/// - [Password]: Constructs a [Password] component with the default theme.
/// - [Password.withTheme]: Constructs a [Password] component with a supplied theme.
///
/// Properties:
/// - [theme]: The theme for the component.
/// - [prompt]: The prompt to be shown together with the user's input.
/// - [confirmation]: Indicates whether to ask for the password again to confirm.
/// - [confirmPrompt]: The prompt to be shown when asking for the password again to confirm.
/// - [confirmError]: The error message to be shown if the repeated password did not match the initial password.
class Password extends StateComponent<String> {
  /// Constructs a [Password] component with the default theme.
  Password({
    required this.prompt,
    this.confirmation = false,
    this.confirmPrompt,
    this.confirmError,
  }) : theme = Theme.defaultTheme;

  /// Constructs a [Password] component with the supplied theme.
  Password.withTheme({
    required this.theme,
    required this.prompt,
    this.confirmation = false,
    this.confirmPrompt,
    this.confirmError,
  });

  /// The theme for the component.
  final Theme theme;

  /// The prompt to be shown together with the user's input.
  final String prompt;

  /// Indicates whether to ask for the password again to confirm.
  final bool confirmation;

  /// The prompt to be shown when asking for the password
  /// againg to confirm.
  final String? confirmPrompt;

  /// The error message to be shown if the repeated password
  /// did not match the initial password.
  final String? confirmError;

  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  late bool hasError;
  int renderCount = 0;

  @override
  void init() {
    super.init();
    hasError = false;
  }

  @override
  void dispose() {
    context.erasePreviousLine(renderCount);
    context.writeln(
      promptSuccess(
        component.prompt,
        theme: component.theme,
        value: component.theme.passwordTheme.passwordPlaceholder * 4,
      ),
    );

    super.dispose();
  }

  @override
  void render() {
    if (hasError) {
      context.writeln(
        promptError(
          component.confirmError ?? 'Passwords do not match',
          theme: component.theme,
        ),
      );
      renderCount++;
    }
  }

  @override
  String interact() {
    while (true) {
      hasError = false;
      context.write(
        promptInput(
          theme: component.theme,
          message: component.prompt,
        ),
      );

      final password = context.readLine(noRender: true);

      if (component.confirmation) {
        context.write(
          promptInput(
            theme: component.theme,
            message: component.confirmPrompt ?? component.prompt,
          ),
        );

        final repeated = context.readLine(noRender: true);

        if (password != repeated) {
          setState(() {
            hasError = true;
          });
          continue;
        }
      }

      return password;
    }
  }
}
