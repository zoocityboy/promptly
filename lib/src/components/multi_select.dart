import 'package:dart_console/dart_console.dart';
import 'package:promptly/src/framework/framework.dart';
import 'package:promptly/src/theme/theme.dart';
import 'package:promptly/src/utils/prompt.dart';

/// A multiple select or checkbox input component.
class MultiSelect extends Component<List<int>> {
  /// Constructs a [MultiSelect] component with the default theme.
  MultiSelect({
    required this.prompt,
    required this.choices,
    this.defaults,
  }) : theme = Theme.defaultTheme;

  /// Constructs a [MultiSelect] component with the supplied theme.
  MultiSelect.withTheme({
    required this.prompt,
    required this.choices,
    required this.theme,
    this.defaults,
  });

  /// The theme of the component.
  final Theme theme;

  /// The prompt to be shown together with the user's input.
  final String prompt;

  /// The [List] of available [String] options to show to
  /// the user.
  final List<String> choices;

  /// The default values to indicate which options are checked.
  final List<bool>? defaults;

  @override
  _MultiSelectState createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  late List<int> selection;
  late int index;

  SelectTheme get theme => component.theme.selectTheme;

  @override
  void init() {
    super.init();

    index = 0;
    selection = [];
    if (component.choices.isEmpty) {
      throw Exception("Options can't be empty");
    }

    if (component.defaults != null) {
      if (component.defaults!.length != component.choices.length) {
        throw Exception(
          'Default selections have a different length of '
          '${component.defaults!.length} '
          'than options of ${component.choices.length}',
        );
      } else {
        selection.addAll(
          component.defaults!.asMap().entries.where((entry) => entry.value).map((entry) => entry.key),
        );
      }
    }

    context.writeln(
      promptInput(
        theme: component.theme.promptTheme,
        message: component.prompt,
      ),
    );
    context.hideCursor();
  }

  @override
  void dispose() {
    final values = selection.map((x) => component.choices[x]).map(theme.inactiveStyle).join('☃︎ ');

    context.writeln(
      promptSuccess(
        theme: component.theme.promptTheme,
        message: component.prompt,
        value: values,
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

      if (component.theme.showActiveCursor) {
        if (i == index) {
          line.write(theme.activeLabel);
        } else {
          line.write(theme.inactiveLabel);
        }
        line.write(' ');
      }

      if (selection.contains(i)) {
        line.write(theme.checkedLabel);
      } else {
        line.write(theme.uncheckedLabel);
      }

      line.write(' ');

      if (i == index) {
        line.write(theme.activeStyle(option));
      } else {
        line.write(theme.inactiveStyle(option));
      }
      context.writeln(line.toString());
    }
  }

  @override
  List<int> interact() {
    while (true) {
      final key = context.readKey();

      if (key.isControl) {
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
            return selection;
          default:
            break;
        }
      } else {
        if (key.char == ' ') {
          setState(() {
            _toggle(index);
          });
        }
      }
    }
  }

  void _toggle(int n) {
    if (selection.contains(n)) {
      selection.remove(n);
    } else {
      selection.add(n);
    }
  }
}
