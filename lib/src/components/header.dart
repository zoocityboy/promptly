import 'package:promptly/src/framework/framework.dart';
import 'package:promptly/src/theme/theme.dart';
import 'package:promptly/src/utils/string_buffer.dart';

class Header extends Component<String> {
  Header({
    required this.title,
    String? prefix,
    this.message,
  })  : theme = Theme.defaultTheme,
        prefix = prefix ?? Theme.defaultTheme.symbols.header;

  Header.withTheme({
    required this.theme,
    String? prefix,
    required this.title,
    this.message,
  }) : prefix = prefix ?? theme.symbols.header;
  final Theme theme;
  final String title;
  final String prefix;
  final String? message;

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  String? value;
  HeaderTheme get theme => component.theme.headerTheme;

  String header(String title, {String? message}) {
    final sb = StringBuffer();
    sb.write(component.theme.colors.prefix(component.prefix.padRight(component.theme.spacing - 1)));
    sb.write(theme.title(' $title '));
    if (message != null) {
      sb.write(' ');
      sb.write(theme.message(message));
    }
    sb.write('\n');
    sb.verticalLine();
    return sb.toString();
  }

  @override
  void dispose() {
    value ??= header(
      component.title,
      message: component.message,
    );
    context.write(value!);
    super.dispose();
  }

  @override
  String interact() {
    final val = header(
      component.title,
      message: component.message,
    );
    setState(() {
      value = val;
    });
    return value!;
  }
}
