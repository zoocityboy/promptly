part of 'theme.dart';

/// A class that defines the theme for links, including styles for different link states.
///
/// The `LinkTheme` class provides a way to customize the appearance of links in different states
/// such as normal, visited, hover, and active. It uses `StyleFunction` to define the styles.
///
/// The class includes:
/// - `linkStyle`: The style for normal links.
/// - `visitedStyle`: The style for visited links.
/// - `hoverStyle`: The style for links when hovered over.
/// - `activeStyle`: The style for active links.
///
/// The class also provides factory constructors to create a `LinkTheme` from default colors or
/// from a set of custom colors. Additionally, it includes a `copyWith` method to create a copy
/// of the `LinkTheme` with some properties overridden.
///
/// Example usage:
/// ```dart
/// final theme = LinkTheme.fromDefault();
/// final customTheme = theme.copyWith(
///   linkStyle: (x) => x.red(),
/// );
/// ```
///
/// The `defaultTheme` static property provides a default link theme with predefined styles.

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
