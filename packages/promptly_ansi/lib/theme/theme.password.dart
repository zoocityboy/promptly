part of 'theme.dart';

class PasswordTheme {
  final String passwordPlaceholder;
  final StyleFunction passwordStyle;
  final StyleFunction passwordStrengthStyle;

  const PasswordTheme({
    required this.passwordPlaceholder,
    required this.passwordStyle,
    required this.passwordStrengthStyle,
  });
  factory PasswordTheme.fromDefault() => PasswordTheme.fromColors(ThemeColors.defaultColors);
  factory PasswordTheme.fromColors(ThemeColors colors) {
    return PasswordTheme(
      passwordPlaceholder: '•',
      passwordStyle: (x) => colors.value(x),
      passwordStrengthStyle: (x) => colors.value(x),
    );
  }

  PasswordTheme copyWith({
    String? passwordPlaceholder,
    StyleFunction? passwordStyle,
    StyleFunction? passwordStrengthStyle,
  }) {
    return PasswordTheme(
      passwordPlaceholder: passwordPlaceholder ?? this.passwordPlaceholder,
      passwordStyle: passwordStyle ?? this.passwordStyle,
      passwordStrengthStyle: passwordStrengthStyle ?? this.passwordStrengthStyle,
    );
  }

  static final PasswordTheme defaultTheme = PasswordTheme(
    passwordPlaceholder: '•',
    passwordStyle: (x) => x.darkGray(),
    passwordStrengthStyle: (x) => x.yellow(),
  );
}
