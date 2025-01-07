import 'package:dart_console/dart_console.dart';
import 'package:promptly/src/framework/framework.dart';
import 'package:promptly/src/theme/theme.dart';
import 'package:promptly/src/utils/prompt.dart';

/// A selector component.
class Select extends StateComponent<int> {
  /// Constructs a [Select] component with the default theme.
  Select({
    required this.prompt,
    required this.choices,
    this.initialIndex = 0,
  }) : theme = Theme.defaultTheme;

  /// Constructs a [Select] component with the supplied theme.
  Select.withTheme({
    required this.prompt,
    required this.choices,
    required this.theme,
    this.initialIndex = 0,
  });

  /// The theme of the component.
  final Theme theme;

  /// The prompt to be shown together with the user's input.
  final String prompt;

  /// The index to be selected by default.
  ///
  /// Will be `0` by default.
  final int initialIndex;

  /// The [List] of available [String] options to show
  /// to the user.
  final List<String> choices;

  @override
  _SelectState createState() => _SelectState();
}

class _SelectState extends State<Select> {
  int index = 0;
  SelectTheme get theme => component.theme.selectTheme;
  @override
  void init() {
    super.init();

    if (component.choices.isEmpty) {
      throw Exception("Options can't be empty");
    }

    if (component.choices.length - 1 < component.initialIndex) {
      throw Exception("Default value is out of options' range");
    } else {
      index = component.initialIndex;
    }

    context.writeln(
      promptInput(
        theme: component.theme,
        message: component.prompt,
      ),
    );
    context.hideCursor();
  }

  @override
  void dispose() {
    context.writeln(
      promptSuccess(
        component.prompt,
        theme: component.theme,
        value: component.choices[index],
      ),
    );
    context.showCursor();

    super.dispose();
  }

  @override
  void render() {
    for (var i = 0; i < component.choices.length; i++) {
      final option = component.choices[i];
      final line = StringBuffer();

      if (i == index) {
        line.write(theme.activeStyle(theme.activeLabel));
        line.write(' ');
        line.write(theme.activeStyle(option));
      } else {
        line.write(theme.inactiveStyle(theme.inactiveLabel));
        line.write(' ');
        line.write(theme.inactiveStyle(option));
      }
      context.writeln(line.toString());
    }
  }

  @override
  int interact() {
    while (true) {
      final key = context.readKey();

      switch (key.controlChar) {
        case ControlCharacter.arrowUp:
          setState(() {
            index = (index - 1) % component.choices.length;
          });
        case ControlCharacter.arrowDown:
          setState(() {
            index = (index + 1) % component.choices.length;
          });
        case ControlCharacter.enter:
          return index;
        default:
          break;
      }
    }
  }
}
