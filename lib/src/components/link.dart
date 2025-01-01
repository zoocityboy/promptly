import 'package:promptly/src/framework/framework.dart';
import 'package:promptly/src/theme/theme.dart';

class Link extends Component<String> {
  Link({
    required this.uri,
    this.message,
  }) : theme = Theme.defaultTheme;

  Link.withTheme({
    required this.theme,
    required this.uri,
    this.message,
  });

  /// The theme for the component.
  final Theme theme;
  final Uri uri;
  final String? message;

  @override
  _LinkState createState() => _LinkState();

  String call() => interact();
}

class _LinkState extends State<Link> {
  String? value;
  LinkTheme get theme => component.theme.linkTheme;

  /// Wraps [uri] with an escape sequence so it's recognized as a hyperlink.
  /// An optional message can be used in place of the [uri].
  /// If no [message] is provided, the text content will be the full [uri].
  ///
  /// ```dart
  /// final plainLink = link(uri: Uri.parse('https://dart.dev'));
  /// print(plainLink); // Equivalent to `[https://dart.dev](https://dart.dev)` in markdown
  ///
  /// final richLink = link(uri: Uri.parse('https://dart.dev'), message: 'The Dart Website');
  /// print(richLink); // Equivalent to `[The Dart Website](https://dart.dev)` in markdown
  /// ```
  String link({required Uri uri, String? message}) {
    const leading = '\x1B]8;;';
    const trailing = '\x1B\\';

    return '$leading${theme.linkStyle(uri.toString())}$trailing${message ?? uri}$leading$trailing';
  }

  @override
  void render() {
    value ??= link(uri: component.uri, message: component.message);
    context.writeln(value);
  }

  @override
  String interact() {
    final line = link(uri: component.uri, message: component.message);
    setState(() {
      value = line;
    });
    return value!;
  }
}
