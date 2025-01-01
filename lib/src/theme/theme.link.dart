part of 'theme.dart';

class LinkTheme {
  final StyleFunction linkStyle;
  final StyleFunction visitedStyle;
  final StyleFunction hoverStyle;
  final StyleFunction activeStyle;

  const LinkTheme({
    required this.linkStyle,
    required this.visitedStyle,
    required this.hoverStyle,
    required this.activeStyle,
  });
  factory LinkTheme.fromDefault() => LinkTheme.fromColors(ThemeColors.defaultColors);
  factory LinkTheme.fromColors(ThemeColors colors) {
    return LinkTheme(
      linkStyle: (x) => colors.active(x).underline(),
      visitedStyle: (x) => colors.active(x),
      hoverStyle: (x) => colors.active(x).underline(),
      activeStyle: (x) => colors.active(x).underline(),
    );
  }

  LinkTheme copyWith({
    StyleFunction? linkStyle,
    StyleFunction? visitedStyle,
    StyleFunction? hoverStyle,
    StyleFunction? activeStyle,
  }) {
    return LinkTheme(
      linkStyle: linkStyle ?? this.linkStyle,
      visitedStyle: visitedStyle ?? this.visitedStyle,
      hoverStyle: hoverStyle ?? this.hoverStyle,
      activeStyle: activeStyle ?? this.activeStyle,
    );
  }

  static final LinkTheme defaultTheme = LinkTheme(
    linkStyle: (x) => x.blue(),
    visitedStyle: (x) => x.blue(),
    hoverStyle: (x) => x.blue().underline(),
    activeStyle: (x) => x.blue().underline(),
  );
}
