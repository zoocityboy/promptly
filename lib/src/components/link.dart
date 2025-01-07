import 'package:promptly/src/framework/framework.dart';
import 'package:promptly/src/theme/theme.dart';

class Link extends TypeComponent<String> {
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

  String link({required Uri uri, String? message}) {
    const leading = '\x1B]8;;';
    const trailing = '\x1B\\';

    return '$leading${theme.linkTheme.linkStyle(uri.toString())}$trailing${message ?? uri}$leading$trailing';
  }

  @override
  void render({Context? context}) {
    (context ?? Context()).writeln(link(uri: uri, message: message));
  }

  @override
  String interact() => link(uri: uri, message: message);
}
