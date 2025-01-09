part of 'theme.dart';

/// A class that defines the theme for selection components.
///
/// The `SelectTheme` class contains various labels and styles for different
/// states of a selection component, such as active, inactive, selected,
/// checked, unchecked, and picked.
///
/// The class provides two factory constructors:
/// - `SelectTheme.fromDefault()`: Creates a `SelectTheme` instance with default colors.
/// - `SelectTheme.fromColors(ThemeColors colors)`: Creates a `SelectTheme` instance with the specified colors.
///
/// The `copyWith` method allows creating a copy of the current `SelectTheme` instance
/// with some properties replaced by new values.
///
/// The `defaultTheme` static property provides a default theme instance.
///
/// Properties:
/// - `activeLabel`: The label for the active state.
/// - `activeStyle`: The style function for the active state.
/// - `inactiveLabel`: The label for the inactive state.
/// - `inactiveStyle`: The style function for the inactive state.
/// - `selectedLabel`: The label for the selected state.
/// - `selectedStyle`: The style function for the selected state.
/// - `checkedLabel`: The label for the checked state.
/// - `checkedStyle`: The style function for the checked state.
/// - `uncheckedLabel`: The label for the unchecked state.
/// - `uncheckedStyle`: The style function for the unchecked state.
/// - `pickedLabel`: The label for the picked state.
/// - `pickedStyle`: The style function for the picked state.
///
/// Example usage:
/// ```dart
/// final theme = SelectTheme.fromDefault();
/// final customTheme = theme.copyWith(activeLabel: '>>');
/// ```

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
    return SelectTheme.fromColors(ThemeColors.defaultColors, ThemeSymbols.defaultSymbols);
  }
  factory SelectTheme.fromColors(ThemeColors colors, ThemeSymbols symbols) {
    return SelectTheme(
      activeLabel: symbols.select.padLeft(4),
      activeStyle: (x) => colors.active(x),
      inactiveLabel: symbols.unselect.padLeft(4),
      inactiveStyle: (x) => colors.inactive(x),
      selectedLabel: symbols.select.padLeft(4),
      selectedStyle: (x) => colors.success(x),
      checkedLabel: symbols.checked.padLeft(4),
      checkedStyle: (x) => colors.success(x),
      uncheckedLabel: symbols.unchecked.padLeft(4),
      uncheckedStyle: (x) => colors.inactive(x),
      pickedLabel: symbols.select.padLeft(4),
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
}
