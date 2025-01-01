part of 'theme.dart';

class LoaderTheme {
  final StyleFunction defaultStyle;
  final StyleFunction errorStyle;
  final StyleFunction successStyle;

  final List<String> spinners;
  final int interval;

  final String successPrefix;
  final String errorPrefix;

  const LoaderTheme({
    required this.defaultStyle,
    required this.errorStyle,
    required this.successStyle,
    required this.spinners,
    required this.interval,
    required this.successPrefix,
    required this.errorPrefix,
  });

  factory LoaderTheme.fromDefault() => LoaderTheme.fromColors(ThemeColors.defaultColors);
  factory LoaderTheme.fromColors(ThemeColors colors) {
    return LoaderTheme(
      defaultStyle: (x) => colors.active(x),
      errorStyle: (x) => colors.error(x),
      successStyle: (x) => colors.success(x),
      spinners: '⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'.split(''),
      interval: 80,
      successPrefix: '✔',
      errorPrefix: '✖',
    );
  }

  LoaderTheme copyWith({
    StyleFunction? defaultStyle,
    StyleFunction? errorStyle,
    StyleFunction? successStyle,
    StyleFunction? spinnerStyle,
    List<String>? spinners,
    int? interval,
    String? successPrefix,
    String? errorPrefix,
  }) {
    return LoaderTheme(
      defaultStyle: defaultStyle ?? this.defaultStyle,
      errorStyle: errorStyle ?? this.errorStyle,
      successStyle: successStyle ?? this.successStyle,
      spinners: spinners ?? this.spinners,
      interval: interval ?? this.interval,
      successPrefix: successPrefix ?? this.successPrefix,
      errorPrefix: errorPrefix ?? this.errorPrefix,
    );
  }

  static final LoaderTheme defaultTheme = LoaderTheme(
    defaultStyle: (x) => ThemeColors.defaultColors.active(x),
    errorStyle: (x) => ThemeColors.defaultColors.error(x),
    successStyle: (x) => ThemeColors.defaultColors.success(x),
    spinners: '⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'.split(''),
    interval: 80,
    successPrefix: '✔',
    errorPrefix: '✖',
  );
}
