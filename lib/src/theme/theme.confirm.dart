part of 'theme.dart';
/// A theme class for confirmation prompts.
///
/// The [ConfirmTheme] class defines the styling and theming for confirmation
/// prompts. It includes a default style and an optional prompt theme.
///
/// The class provides factory constructors to create a [ConfirmTheme] from
/// default values or from specific colors and symbols.
///
/// The [copyWith] method allows creating a copy of the current theme with
/// optional new values for the default style and prompt theme.
///
/// Properties:
/// - [defaultStyle]: A function that defines the default style.
/// - [promptTheme]: An optional [PromptTheme] for additional theming.
///
/// Constructors:
/// - [ConfirmTheme._]: A private constructor used internally.
/// - [ConfirmTheme.fromDefault]: Creates a [ConfirmTheme] with default colors
///   and symbols.
/// - [ConfirmTheme.fromColors]: Creates a [ConfirmTheme] with specified colors
///   and symbols.
///
/// Methods:
/// - [copyWith]: Creates a copy of the current theme with optional new values.

class ConfirmTheme {
  final StyleFunction defaultStyle;
  final PromptTheme? promptTheme;

  const ConfirmTheme._({
    required this.defaultStyle,
    this.promptTheme,
  });
  factory ConfirmTheme.fromDefault() {
    return ConfirmTheme.fromColors(
      ThemeColors.defaultColors,
      ThemeSymbols.defaultSymbols,
    );
  }
  factory ConfirmTheme.fromColors(ThemeColors colors, ThemeSymbols symbols) {
    return ConfirmTheme._(
      defaultStyle: (x) => colors.value(x),
      promptTheme: PromptTheme.fromColors(colors, symbols),
    );
  }

  ConfirmTheme copyWith({
    StyleFunction? defaultStyle,
    PromptTheme? promptTheme,
  }) {
    return ConfirmTheme._(
      defaultStyle: defaultStyle ?? this.defaultStyle,
      promptTheme: promptTheme ?? promptTheme,
    );
  }
}
