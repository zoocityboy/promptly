part of 'theme.dart';

class PromptTheme {
  final String promptPrefix;
  final String promptSuffix;
  final String successPrefix;
  final String successSuffix;
  final String errorPrefix;

  final StyleFunction messageStyle;
  final StyleFunction valueStyle;
  final StyleFunction hintStyle;
  final StyleFunction errorStyle;

  const PromptTheme._({
    required this.promptPrefix,
    required this.promptSuffix,
    required this.successPrefix,
    required this.successSuffix,
    required this.errorPrefix,
    required this.messageStyle,
    required this.valueStyle,
    required this.hintStyle,
    required this.errorStyle,
  });
  factory PromptTheme.fromDefault() => PromptTheme.fromColors(ThemeColors.defaultColors, ThemeSymbols.defaultSymbols);
  // ignore: avoid_unused_constructor_parameters
  factory PromptTheme.fromColors(ThemeColors colors, ThemeSymbols symbols) {
    return PromptTheme._(
      promptPrefix: '?'.padRight(3).brightGreen().dim(),
      promptSuffix: '›'.padLeft(2).darkGray(),
      successPrefix: '◆'.padRight(3).brightGreen().dim(),
      successSuffix: '✔'.padRight(3).brightGreen().dim(),
      errorPrefix: '■'.padRight(3).brightRed().dim(),
      messageStyle: (x) => colors.text(x),
      valueStyle: (x) => colors.value(x),
      hintStyle: (x) => colors.hint(x),
      errorStyle: (x) => colors.error(x),
    );
  }

  PromptTheme copyWith({
    String? promptPrefix,
    String? promptSuffix,
    String? successPrefix,
    String? successSuffix,
    String? errorPrefix,
    StyleFunction? messageStyle,
    StyleFunction? valueStyle,
    StyleFunction? hintStyle,
    StyleFunction? errorStyle,
  }) {
    return PromptTheme._(
      promptPrefix: promptPrefix ?? this.promptPrefix,
      promptSuffix: promptSuffix ?? this.promptSuffix,
      errorPrefix: errorPrefix ?? this.errorPrefix,
      successPrefix: successPrefix ?? this.successPrefix,
      successSuffix: successSuffix ?? this.successSuffix,
      messageStyle: messageStyle ?? this.messageStyle,
      valueStyle: valueStyle ?? this.valueStyle,
      hintStyle: hintStyle ?? this.hintStyle,
      errorStyle: errorStyle ?? this.errorStyle,
    );
  }

  // static final PromptTheme defaultTheme = PromptTheme._(
  //   promptPrefix: '?'.padRight(3).brightGreen().dim(),
  //   promptSuffix: '›'.padLeft(2).darkGray(),
  //   successPrefix: '◆'.padRight(3).brightGreen().dim(),
  //   successSuffix: '✔'.padRight(3).brightGreen().dim(),
  //   errorPrefix: '■'.padRight(3).brightRed().dim(),
  //   messageStyle: (x) => x.white().dim(),
  //   valueStyle: (x) => x.green(),
  //   hintStyle: (x) => x.gray(),
  //   errorStyle: (p0) => p0.brightRed(),
  // );
}
