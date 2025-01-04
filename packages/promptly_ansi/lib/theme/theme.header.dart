part of 'theme.dart';

class HeaderTheme {
  HeaderTheme({
    required this.title,
    required this.message,
  });
  final StyleFunction title;
  final StyleFunction message;
  factory HeaderTheme.fromDefault() => HeaderTheme.fromColors(ThemeColors.defaultColors);
  factory HeaderTheme.fromColors(ThemeColors colors) {
    return HeaderTheme(
      title: (x) => colors.successBlock(x),
      message: (x) => colors.hint(x),
    );
  }

  HeaderTheme copyWith({
    StyleFunction? title,
    StyleFunction? message,
  }) {
    return HeaderTheme(
      title: title ?? this.title,
      message: message ?? this.message,
    );
  }
}
