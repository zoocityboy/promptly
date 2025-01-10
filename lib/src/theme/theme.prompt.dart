part of 'theme.dart';

/// A class representing the theme for prompts, including styles and prefixes/suffixes for different states.
class PromptTheme {
  /// The prefix for the prompt.
  final String promptPrefix;

  /// The suffix for the prompt.
  final String promptSuffix;

  /// The prefix for success messages.
  final String successPrefix;

  /// The suffix for success messages.
  final String successSuffix;

  /// The prefix for error messages.
  final String errorPrefix;

  /// The style function for general messages.
  final StyleFunction messageStyle;

  /// The style function for values.
  final StyleFunction valueStyle;

  /// The style function for hints.
  final StyleFunction hintStyle;

  /// The style function for errors.
  final StyleFunction errorStyle;

  /// Private constructor for creating a [PromptTheme] instance.
  const PromptTheme._({
    required this.promptPrefix,
    required this.promptSuffix,
    required this.successPrefix,
    required this.successSuffix,
    required this.errorPrefix,
    required this.messageStyle,
    required this.valueStyle,
    required this.hintStyle,
    required this.errorStyle,
  });

  /// Factory constructor to create a [PromptTheme] instance with default colors and symbols.
  factory PromptTheme.fromDefault() => PromptTheme.fromColors(
        ThemeColors.defaultColors,
        ThemeSymbols.defaultSymbols,
      );

  /// Factory constructor to create a [PromptTheme] instance with specified colors and symbols.
  factory PromptTheme.fromColors(ThemeColors colors, ThemeSymbols symbols) {
    // ignore: unused_local_variable
    final ast = symbols.activeStep;
    return PromptTheme._(
      promptPrefix: '?'.padRight(3).brightGreen().dim(),
      promptSuffix: '›'.padLeft(2).darkGray(),
      successPrefix: symbols.success.padRight(3).brightGreen().dim(),
      successSuffix: symbols.success.padRight(3).brightGreen().dim(),
      errorPrefix: symbols.error.padRight(3).brightRed().dim(),
      messageStyle: (x) => colors.text(x),
      valueStyle: (x) => colors.value(x),
      hintStyle: (x) => colors.hint(x),
      errorStyle: (x) => colors.error(x),
    );
  }

  /// Creates a copy of the current [PromptTheme] with optional new values.
  PromptTheme copyWith({
    String? promptPrefix,
    String? promptSuffix,
    String? successPrefix,
    String? successSuffix,
    String? errorPrefix,
    StyleFunction? messageStyle,
    StyleFunction? valueStyle,
    StyleFunction? hintStyle,
    StyleFunction? errorStyle,
  }) {
    return PromptTheme._(
      promptPrefix: promptPrefix ?? this.promptPrefix,
      promptSuffix: promptSuffix ?? this.promptSuffix,
      errorPrefix: errorPrefix ?? this.errorPrefix,
      successPrefix: successPrefix ?? this.successPrefix,
      successSuffix: successSuffix ?? this.successSuffix,
      messageStyle: messageStyle ?? this.messageStyle,
      valueStyle: valueStyle ?? this.valueStyle,
      hintStyle: hintStyle ?? this.hintStyle,
      errorStyle: errorStyle ?? this.errorStyle,
    );
  }
}

/// A class representing the theme for error messages, including styles and prefixes.
class ErrorTheme {
  /// The prefix for error messages.
  final String prefix;

  /// The style function for the prefix.
  final StyleFunction prefixStyle;

  /// The style function for error messages.
  final StyleFunction messageStyle;

  /// Private constructor for creating an [ErrorTheme] instance.
  const ErrorTheme._({
    required this.prefix,
    required this.prefixStyle,
    required this.messageStyle,
  });

  /// Factory constructor to create an [ErrorTheme] instance with default colors and symbols.
  factory ErrorTheme.fromDefault() => ErrorTheme.fromColors(
        ThemeColors.defaultColors,
        ThemeSymbols.defaultSymbols,
      );

  /// Factory constructor to create an [ErrorTheme] instance with specified colors and symbols.
  factory ErrorTheme.fromColors(ThemeColors colors, ThemeSymbols symbols) {
    return ErrorTheme._(
      prefix: symbols.error.padRight(3).brightRed().dim(),
      prefixStyle: (x) => colors.error(x),
      messageStyle: (x) => colors.text(x),
    );
  }
}

/// A class representing the theme for success messages, including styles and prefixes.
class SuccessTheme {
  /// The prefix for success messages.
  final String prefix;

  /// The style function for the prefix.
  final StyleFunction prefixStyle;

  /// The style function for success messages.
  final StyleFunction messageStyle;

  /// Private constructor for creating a [SuccessTheme] instance.
  const SuccessTheme._({
    required this.prefix,
    required this.prefixStyle,
    required this.messageStyle,
  });

  /// Factory constructor to create a [SuccessTheme] instance with default colors and symbols.
  factory SuccessTheme.fromDefault() => SuccessTheme.fromColors(
        ThemeColors.defaultColors,
        ThemeSymbols.defaultSymbols,
      );

  /// Factory constructor to create a [SuccessTheme] instance with specified colors and symbols.
  factory SuccessTheme.fromColors(ThemeColors colors, ThemeSymbols symbols) {
    return SuccessTheme._(
      prefix: symbols.success.padRight(3).brightGreen().dim(),
      prefixStyle: (x) => colors.success(x),
      messageStyle: (x) => colors.text(x),
    );
  }
}
