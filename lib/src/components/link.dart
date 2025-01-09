import 'package:promptly/src/framework/framework.dart';
import 'package:promptly/src/theme/theme.dart';

/// A component that represents a hyperlink.
///
/// The [Link] class extends [TypeComponent] with a type parameter of [String].
/// It provides functionality to render and interact with a hyperlink, optionally
/// with a message and a specific theme.
///
/// The [Link] can be created with a default theme using the default constructor,
/// or with a custom theme using the [Link.withTheme] constructor.
///
/// The [uri] parameter is required and represents the URI of the link.
/// The [message] parameter is optional and represents the text to display for the link.
/// The [context] parameter is optional and represents the context in which the link is rendered.
///
/// The [theme] property holds the theme for the component.
/// The [uri] property holds the URI of the link.
/// The [message] property holds the optional message to display for the link.
/// The [_context] property holds the context in which the link is rendered.
///
/// The [_formatted] getter returns the formatted link string with ANSI escape codes.
///
/// The [render] method writes the formatted link to the provided or internal context.
///
/// The [interact] method returns the formatted link string.
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
