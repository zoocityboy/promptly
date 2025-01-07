part of 'theme.dart';

class ConfirmTheme {
  final StyleFunction defaultStyle;
  final PromptTheme? promptTheme;

  const ConfirmTheme._({
    required this.defaultStyle,
    this.promptTheme,
  });
  factory ConfirmTheme.fromDefault() {
    return ConfirmTheme.fromColors(
      ThemeColors.defaultColors,
      ThemeSymbols.defaultSymbols,
    );
  }
  factory ConfirmTheme.fromColors(ThemeColors colors, ThemeSymbols symbols) {
    return ConfirmTheme._(
      defaultStyle: (x) => colors.value(x),
      promptTheme: PromptTheme.fromColors(colors, symbols),
    );
  }

  ConfirmTheme copyWith({
    StyleFunction? defaultStyle,
    PromptTheme? promptTheme,
  }) {
    return ConfirmTheme._(
      defaultStyle: defaultStyle ?? this.defaultStyle,
      promptTheme: promptTheme ?? promptTheme,
    );
  }
}
