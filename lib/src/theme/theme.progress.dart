part of 'theme.dart';
/// A class that defines the theme for a progress indicator.
///
/// The [ProgressTheme] class allows customization of the appearance of a progress
/// indicator by specifying various styles and characters for different parts of the
/// indicator, such as the prefix, suffix, empty, filled, and leading segments.
///
/// The class provides two factory constructors:
/// - [ProgressTheme.fromDefault]: Creates a [ProgressTheme] using the default colors.
/// - [ProgressTheme.fromColors]: Creates a [ProgressTheme] using the specified [ThemeColors].
///
/// The class also provides a [copyWith] method to create a copy of the current theme
/// with some properties replaced by new values.
///
/// Properties:
/// - [prefix]: The prefix character(s) for the progress indicator.
/// - [suffix]: The suffix character(s) for the progress indicator.
/// - [empty]: The character(s) representing the empty part of the progress indicator.
/// - [filled]: The character(s) representing the filled part of the progress indicator.
/// - [leading]: The character(s) representing the leading part of the progress indicator.
/// - [emptyStyle]: A function to style the empty part of the progress indicator.
/// - [filledStyle]: A function to style the filled part of the progress indicator.
/// - [leadingStyle]: A function to style the leading part of the progress indicator.
///
/// Example usage:
/// ```dart
/// final theme = ProgressTheme.fromDefault();
/// final customTheme = theme.copyWith(prefix: '(', suffix: ')');
/// ```

class ProgressTheme {
  final String prefix;
  final String suffix;
  final String empty;
  final String filled;
  final String leading;
  final StyleFunction emptyStyle;
  final StyleFunction filledStyle;
  final StyleFunction leadingStyle;

  const ProgressTheme._({
    required this.prefix,
    required this.suffix,
    required this.empty,
    required this.filled,
    required this.leading,
    required this.emptyStyle,
    required this.filledStyle,
    required this.leadingStyle,
  });
  factory ProgressTheme.fromDefault() {
    return ProgressTheme.fromColors(ThemeColors.defaultColors);
  }
  factory ProgressTheme.fromColors(ThemeColors colors) {
    return ProgressTheme._(
      prefix: colors.prefix('['),
      suffix: colors.prefix(']'),
      empty: '─',
      filled: '─'.bold(),
      leading: '─'.bold(),
      emptyStyle: (x) => colors.prefix(x),
      filledStyle: (x) => colors.active(x),
      leadingStyle: (x) => colors.success(x),
    );
  }

  ProgressTheme copyWith({
    String? prefix,
    String? suffix,
    String? empty,
    String? filled,
    String? leading,
    StyleFunction? emptyStyle,
    StyleFunction? filledStyle,
    StyleFunction? leadingStyle,
  }) {
    return ProgressTheme._(
      prefix: prefix ?? this.prefix,
      suffix: suffix ?? this.suffix,
      empty: empty ?? this.empty,
      filled: filled ?? this.filled,
      leading: leading ?? this.leading,
      emptyStyle: emptyStyle ?? this.emptyStyle,
      filledStyle: filledStyle ?? this.filledStyle,
      leadingStyle: leadingStyle ?? this.leadingStyle,
    );
  }

  static final ProgressTheme defaultTheme = ProgressTheme._(
    prefix: '['.darkGray(),
    suffix: ']'.darkGray(),
    empty: '─',
    filled: '─'.bold(),
    leading: '─'.bold(),
    emptyStyle: (x) => x.darkGray(),
    filledStyle: (x) => x.brightGreen(),
    leadingStyle: (x) => x.green(),
  );
}
