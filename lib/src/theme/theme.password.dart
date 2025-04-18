part of 'theme.dart';

/// A class that defines the theme for password-related UI elements.
///
/// The [PasswordTheme] class contains properties and methods to customize
/// the appearance and behavior of password fields, including placeholder
/// text, password style, and password strength style.
///
/// Properties:
/// - [passwordPlaceholder]: A string representing the placeholder text for the password field.
/// - [passwordStyle]: A function that defines the style of the password text.
/// - [passwordStrengthStyle]: A function that defines the style of the password strength indicator.
///
/// Constructors:
/// - [PasswordTheme]: Creates a new instance of [PasswordTheme] with the specified properties.
/// - [PasswordTheme.fromDefault]: Creates a new instance of [PasswordTheme] with default colors.
/// - [PasswordTheme.fromColors]: Creates a new instance of [PasswordTheme] with the specified colors.
///
/// Methods:
/// - [copyWith]: Creates a copy of the current [PasswordTheme] with the option to override specific properties.
///
/// Static Properties:
/// - [defaultTheme]: A default instance of [PasswordTheme] with predefined styles.

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
