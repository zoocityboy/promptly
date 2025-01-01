import 'package:dart_console/dart_console.dart';
import 'package:promptly/src/framework/framework.dart';
import 'package:promptly/src/theme/theme.dart';
import 'package:promptly/src/utils/prompt.dart';

/// A confirm component.
class Confirm extends Component<bool> {
  /// Constructs a [Confirm] component with the default theme.
  Confirm({
    required this.prompt,
    this.defaultValue,
    this.enterForConfirm = false,
  }) : theme = Theme.defaultTheme;

  /// Constructs a [Confirm] component with the supplied theme.
  Confirm.withTheme({
    required this.theme,
    required this.prompt,
    this.defaultValue,
    this.enterForConfirm = false,
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
        theme: component.theme.promptTheme,
        message: component.prompt,
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
        theme: component.theme.promptTheme,
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
