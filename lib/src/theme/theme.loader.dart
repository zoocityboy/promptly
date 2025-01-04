part of 'theme.dart';

class LoaderTheme {
  final StyleFunction processingStyle;
  final StyleFunction errorStyle;
  final StyleFunction successStyle;

  final List<String> spinners;
  final int interval;

  final String successPrefix;
  final String errorPrefix;

  const LoaderTheme({
    required this.processingStyle,
    required this.errorStyle,
    required this.successStyle,
    required this.spinners,
    required this.interval,
    required this.successPrefix,
    required this.errorPrefix,
  });

  factory LoaderTheme.fromDefault() => LoaderTheme.fromColors(ThemeColors.defaultColors, ThemeSymbols.defaultSymbols);
  factory LoaderTheme.fromColors(ThemeColors colors, ThemeSymbols symbols) {
    return LoaderTheme(
      processingStyle: (x) => colors.active(x),
      errorStyle: (x) => colors.error(x),
      successStyle: (x) => colors.success(x),
      spinners: symbols.spinners,
      interval: 80,
      successPrefix: symbols.successStep,
      errorPrefix: symbols.errorStep,
    );
  }

  LoaderTheme copyWith({
    StyleFunction? processingStyle,
    StyleFunction? errorStyle,
    StyleFunction? successStyle,
    List<String>? spinners,
    int? interval,
    String? successPrefix,
    String? errorPrefix,
  }) {
    return LoaderTheme(
      processingStyle: processingStyle ?? this.processingStyle,
      errorStyle: errorStyle ?? this.errorStyle,
      successStyle: successStyle ?? this.successStyle,
      spinners: spinners ?? this.spinners,
      interval: interval ?? this.interval,
      successPrefix: successPrefix ?? this.successPrefix,
      errorPrefix: errorPrefix ?? this.errorPrefix,
    );
  }
}
