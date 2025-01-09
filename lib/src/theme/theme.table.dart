part of 'theme.dart';

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

class TableTheme {
  const TableTheme({required this.rowTextStyle, required this.headerTextStyle});
  factory TableTheme.fromDefault() => TableTheme.fromColors(ThemeColors.defaultColors);
  factory TableTheme.fromColors(ThemeColors colors) {
    return TableTheme(
      headerTextStyle: (p0) => colors.text(p0),
      rowTextStyle: (p0) => colors.hint(p0),
    );
  }
  final StyleFunction rowTextStyle;
  final StyleFunction headerTextStyle;

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
