part of 'theme.dart';

/// A theme class for customizing the appearance of a selection table.
///
/// The [SelectTableTheme] class allows you to define styles for various
/// elements of a selection table, including the border, header, active items,
/// and inactive items.
///
/// The styles are defined using [StyleFunction]s, which take a parameter and
/// return a style based on that parameter.
///
/// The class provides factory constructors for creating a theme from default
/// colors or from a custom set of colors.
///
/// Example usage:
/// ```dart
/// final theme = SelectTableTheme.fromDefault();
/// ```
///
/// Properties:
/// - [borderStyle]: The style function for the table border.
/// - [headerStyle]: The style function for the table header.
/// - [activeItemStyle]: The style function for active items in the table.
/// - [inactiveItemStyle]: The style function for inactive items in the table.
///
/// Static Members:
/// - [defaultTheme]: A default instance of [SelectTableTheme] using default colors.

class SelectTableTheme {
  final StyleFunction borderStyle;
  final StyleFunction headerStyle;
  final StyleFunction activeItemStyle;
  final StyleFunction inactiveItemStyle;

  const SelectTableTheme({
    required this.borderStyle,
    required this.headerStyle,
    required this.activeItemStyle,
    required this.inactiveItemStyle,
  });
  factory SelectTableTheme.fromDefault() => SelectTableTheme.fromColors(ThemeColors.defaultColors);
  factory SelectTableTheme.fromColors(ThemeColors colors) {
    return SelectTableTheme(
      borderStyle: (x) => colors.hint(x),
      headerStyle: (x) => colors.value(x),
      activeItemStyle: (x) => colors.value(x),
      inactiveItemStyle: (x) => colors.value(x),
    );
  }

  static final SelectTableTheme defaultTheme = SelectTableTheme(
    borderStyle: (x) => ThemeColors.defaultColors.hint(x),
    headerStyle: (x) => ThemeColors.defaultColors.value(x),
    activeItemStyle: (x) => ThemeColors.defaultColors.value(x),
    inactiveItemStyle: (x) => ThemeColors.defaultColors.value(x),
  );
}

/// A class that defines the theme for a table, including text styles for rows and headers.
class TableTheme {
  /// Creates a [TableTheme] with the given [rowTextStyle] and [headerTextStyle].
  const TableTheme({required this.rowTextStyle, required this.headerTextStyle});

  /// Creates a [TableTheme] with default colors.
  factory TableTheme.fromDefault() => TableTheme.fromColors(ThemeColors.defaultColors);

  /// Creates a [TableTheme] from the given [colors].
  factory TableTheme.fromColors(ThemeColors colors) {
    return TableTheme(
      headerTextStyle: (p0) => colors.text(p0),
      rowTextStyle: (p0) => colors.hint(p0),
    );
  }

  /// The text style function for table rows.
  final StyleFunction rowTextStyle;

  /// The text style function for table headers.
  final StyleFunction headerTextStyle;

  /// Creates a copy of this [TableTheme] with the given properties replaced.
  ///
  /// If a property is not provided, the value from the current instance is used.
  TableTheme copyWith({
    StyleFunction? rowTextStyle,
    StyleFunction? headerTextStyle,
  }) {
    return TableTheme(
      rowTextStyle: rowTextStyle ?? this.rowTextStyle,
      headerTextStyle: headerTextStyle ?? this.headerTextStyle,
    );
  }
}
