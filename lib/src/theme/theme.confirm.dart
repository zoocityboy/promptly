part of 'theme.dart';

class ConfirmTheme {
  final StyleFunction defaultStyle;
  final PromptTheme? promptTheme;

  const ConfirmTheme._({
    required this.defaultStyle,
    this.promptTheme,
  });
  factory ConfirmTheme.fromDefault() {
    return ConfirmTheme.fromColors(ThemeColors.defaultColors);
  }
  factory ConfirmTheme.fromColors(ThemeColors colors) {
    return ConfirmTheme._(
      defaultStyle: (x) => colors.value(x),
      promptTheme: PromptTheme.fromColors(colors),
    );
  }

  ConfirmTheme copyWith({
    StyleFunction? defaultStyle,
    PromptTheme? promptTheme,
  }) {
    return ConfirmTheme._(
      defaultStyle: defaultStyle ?? this.defaultStyle,
      promptTheme: promptTheme ?? this.promptTheme,
    );
  }

  static final ConfirmTheme defaultTheme = ConfirmTheme._(
    defaultStyle: (x) => ThemeColors.defaultColors.value(x),
    promptTheme: PromptTheme.defaultTheme,
  );
}
