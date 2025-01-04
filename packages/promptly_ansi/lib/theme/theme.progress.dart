part of 'theme.dart';

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
