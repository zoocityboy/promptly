import 'package:zoo_console/src/framework/framework.dart';
import 'package:zoo_console/src/theme/theme.dart';

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

  return '$leading$uri$trailing${message ?? uri}$leading$trailing';
}

class Link extends Component<String> {
  Link({
    required this.uri,
    this.message,
  }) : theme = Theme.zooTheme;

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
}

class _LinkState extends State<Link> {
  String? value;

  @override
  void init() {
    // TODO: implement init
    super.init();
    value = link(uri: component.uri, message: component.message);
  }

  @override
  void dispose() {
    // context.writeln(link(uri: uri, message: message));
    if (value != null) {
      context.writeln(value);
    }
    super.dispose();
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
