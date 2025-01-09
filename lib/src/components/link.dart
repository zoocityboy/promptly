import 'package:promptly/src/framework/framework.dart';
import 'package:promptly/src/theme/theme.dart';

class Link extends TypeComponent<String> {
  Link({
    required this.uri,
    this.message,
    Context? context,
  })  : theme = Theme.defaultTheme,
        _context = context ?? Context();

  Link.withTheme({
    required this.theme,
    required this.uri,
    this.message,
    Context? context,
  }) : _context = context ?? Context();

  /// The theme for the component.
  final Theme theme;
  final Uri uri;
  final String? message;
  final Context _context;

  String get _formatted {
    const leading = '\x1B]8;;';
    const trailing = '\x1B\\';

    return '$leading${theme.linkTheme.linkStyle(uri.toString())}$trailing${message ?? uri}$leading$trailing';
  }

  @override
  void render({Context? context}) {
    (context ?? _context).writeln(_formatted);
  }

  @override
  String interact() => _formatted;
}
