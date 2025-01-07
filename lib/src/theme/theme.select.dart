part of 'theme.dart';

class SelectTheme {
  final String activeLabel;
  final StyleFunction activeStyle;

  final String inactiveLabel;
  final StyleFunction inactiveStyle;

  final String selectedLabel;
  final StyleFunction selectedStyle;

  final String checkedLabel;
  final StyleFunction checkedStyle;

  final String uncheckedLabel;
  final StyleFunction uncheckedStyle;

  final String pickedLabel;
  final StyleFunction pickedStyle;

  const SelectTheme({
    required this.activeLabel,
    required this.activeStyle,
    required this.inactiveLabel,
    required this.inactiveStyle,
    required this.selectedLabel,
    required this.selectedStyle,
    required this.checkedLabel,
    required this.checkedStyle,
    required this.uncheckedLabel,
    required this.uncheckedStyle,
    required this.pickedLabel,
    required this.pickedStyle,
  });
  factory SelectTheme.fromDefault() {
    return SelectTheme.fromColors(ThemeColors.defaultColors);
  }
  factory SelectTheme.fromColors(ThemeColors colors) {
    return SelectTheme(
      activeLabel: '❯'.padLeft(4),
      activeStyle: (x) => colors.active(x),
      inactiveLabel: ' '.padLeft(4),
      inactiveStyle: (x) => colors.inactive(x),
      selectedLabel: '❯'.padLeft(4),
      selectedStyle: (x) => colors.success(x),
      checkedLabel: '◉'.padLeft(4),
      checkedStyle: (x) => colors.success(x),
      uncheckedLabel: '◯'.padLeft(4),
      uncheckedStyle: (x) => colors.inactive(x),
      pickedLabel: '❯'.padLeft(4),
      pickedStyle: (x) => colors.success(x),
    );
  }

  SelectTheme copyWith({
    String? activeLabel,
    StyleFunction? acttiveStyle,
    String? inactiveLabel,
    StyleFunction? inactiveStyle,
    String? selectedLabel,
    StyleFunction? selectedStyle,
    String? checkedLabel,
    StyleFunction? checkedStyle,
    String? uncheckedLabel,
    StyleFunction? uncheckedStyle,
    String? pickedLabel,
    StyleFunction? pickedStyle,
  }) {
    return SelectTheme(
      activeLabel: activeLabel ?? this.activeLabel,
      activeStyle: acttiveStyle ?? activeStyle,
      inactiveLabel: inactiveLabel ?? this.inactiveLabel,
      inactiveStyle: inactiveStyle ?? this.inactiveStyle,
      selectedLabel: selectedLabel ?? this.selectedLabel,
      selectedStyle: selectedStyle ?? this.selectedStyle,
      checkedLabel: checkedLabel ?? this.checkedLabel,
      checkedStyle: checkedStyle ?? this.checkedStyle,
      uncheckedLabel: uncheckedLabel ?? this.uncheckedLabel,
      uncheckedStyle: uncheckedStyle ?? this.uncheckedStyle,
      pickedLabel: pickedLabel ?? this.pickedLabel,
      pickedStyle: pickedStyle ?? this.pickedStyle,
    );
  }

  static final SelectTheme defaultTheme = SelectTheme(
    activeLabel: '❯'.padLeft(4),
    activeStyle: (x) => ThemeColors.defaultColors.active(x),
    inactiveLabel: ' '.padLeft(4),
    inactiveStyle: (x) => ThemeColors.defaultColors.inactive(x),
    selectedLabel: '❯'.padLeft(4),
    selectedStyle: (x) => ThemeColors.defaultColors.success(x),
    checkedLabel: '◉'.padLeft(4),
    checkedStyle: (x) => ThemeColors.defaultColors.success(x),
    uncheckedLabel: '◯'.padLeft(4),
    uncheckedStyle: (x) => ThemeColors.defaultColors.inactive(x),
    pickedLabel: '❯'.padLeft(4),
    pickedStyle: (x) => ThemeColors.defaultColors.success(x),
  );
}
