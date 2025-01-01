part of 'theme.dart';

class TableTheme {
  final StyleFunction borderStyle;
  final StyleFunction headerStyle;
  final StyleFunction activeItemStyle;
  final StyleFunction inactiveItemStyle;

  const TableTheme({
    required this.borderStyle,
    required this.headerStyle,
    required this.activeItemStyle,
    required this.inactiveItemStyle,
  });
  factory TableTheme.fromDefault() => TableTheme.fromColors(ThemeColors.defaultColors);
  factory TableTheme.fromColors(ThemeColors colors) {
    return TableTheme(
      borderStyle: (x) => colors.hint(x),
      headerStyle: (x) => colors.value(x),
      activeItemStyle: (x) => colors.value(x),
      inactiveItemStyle: (x) => colors.value(x),
    );
  }

  static final TableTheme defaultTheme = TableTheme(
    borderStyle: (x) => ThemeColors.defaultColors.hint(x),
    headerStyle: (x) => ThemeColors.defaultColors.value(x),
    activeItemStyle: (x) => ThemeColors.defaultColors.value(x),
    inactiveItemStyle: (x) => ThemeColors.defaultColors.value(x),
  );
}
