import 'package:dart_console/dart_console.dart';
import 'package:promptly/src/framework/framework.dart';
import 'package:promptly/src/theme/theme.dart';
import 'package:promptly/src/utils/prompt.dart';

/// A confirm component.
///
/// This component displays a prompt to the user and expects a boolean response.
/// It can be customized with a theme, an initial value, and an option to wait
/// for the Enter key after the user has responded.
///
/// Example usage:
/// ```dart
/// Confirm(
///   prompt: 'Are you sure you want to proceed?',
///   defaultValue: true,
///   enterForConfirm: true,
/// );
/// ```
///
/// Example usage with a custom theme:
/// ```dart
/// Confirm.withTheme(
///   theme: customTheme,
///   prompt: 'Are you sure you want to proceed?',
///   defaultValue: false,
///   enterForConfirm: false,
/// );
/// ```
///
/// Properties:
/// - [theme]: The theme of the component.
/// - [prompt]: The prompt to be shown together with the user's input.
/// - [defaultValue]: The value to be used as an initial value.
/// - [enterForConfirm]: Determines whether to wait for the Enter key after the user has responded.
class Confirm extends StateComponent<bool> {
  /// Constructs a [Confirm] component with the default theme.
  Confirm({
    required this.prompt,
    this.defaultValue,
    this.enterForConfirm = false,
    this.value,
  }) : theme = Theme.defaultTheme;

  /// Constructs a [Confirm] component with the supplied theme.
  Confirm.withTheme({
    required this.theme,
    required this.prompt,
    this.defaultValue,
    this.enterForConfirm = false,
    this.value,
  });

  /// The theme of the component.
  final Theme theme;

  /// The prompt to be shown together with the user's input.
  final String prompt;

  /// The value to be used as an initial value.
  final bool? defaultValue;

  /// Determines whether to wait for the Enter key after
  /// the user has responded.
  final bool enterForConfirm;

  final bool? value;

  @override
  _ConfirmState createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  bool? answer;
  ConfirmTheme get theme => component.theme.confirmTheme;

  @override
  void init() {
    super.init();
    if (component.defaultValue != null) {
      answer = component.defaultValue;
    }

    context.hideCursor();
  }

  @override
  void dispose() {
    context.writeln(
      promptSuccess(
        component.prompt,
        theme: component.theme,
        value: answer! ? 'yes' : 'no',
      ),
    );
    context.showCursor();

    super.dispose();
  }

  @override
  void render() {
    final line = StringBuffer();
    line.write(
      promptInput(
        theme: component.theme,
        message: component.prompt,
        hint: 'y/n',
      ),
    );
    if (answer != null) {
      line.write(theme.defaultStyle(answer! ? 'yes' : 'no'));
    }
    context.writeln(line.toString());
  }

  @override
  bool interact() {
    if (component.value != null) {
      setState(() {
        answer = component.value;
      });
      return answer!;
    }
    while (true) {
      final key = context.readKey();

      if (key.isControl) {
        if (key.controlChar == ControlCharacter.enter &&
            answer != null &&
            (component.enterForConfirm || component.defaultValue != null)) {
          return answer!;
        }
      } else {
        switch (key.char.toLowerCase()) {
          case 'y':
            setState(() {
              answer = true;
            });
            if (!component.enterForConfirm) {
              return answer!;
            }
          case 'n':
            setState(() {
              answer = false;
            });
            if (!component.enterForConfirm) {
              return answer!;
            }
          default:
            break;
        }
      }
    }
  }
}
