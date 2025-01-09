part of 'theme.dart';

/// A class that defines the theme for a loader, including styles and symbols
/// for different states (processing, error, success) and spinner animations.
///
/// The [LoaderTheme] class provides customization options for the loader's
/// appearance and behavior. It includes styles for different states, a list
/// of spinner symbols, and prefixes for success and error messages.
///
/// The class also provides factory constructors for creating a default theme
/// or a theme based on specified colors and symbols.
///
/// Example usage:
/// ```dart
/// final theme = LoaderTheme.fromDefault();
/// ```
///
/// Properties:
/// - [processingStyle]: A function that defines the style for the processing state.
/// - [errorStyle]: A function that defines the style for the error state.
/// - [successStyle]: A function that defines the style for the success state.
/// - [spinners]: A list of strings representing spinner symbols.
/// - [interval]: The interval in milliseconds for spinner animation.
/// - [successPrefix]: A prefix string for success messages.
/// - [errorPrefix]: A prefix string for error messages.
///
/// Methods:
/// - [LoaderTheme.fromDefault]: Creates a default loader theme.
/// - [LoaderTheme.fromColors]: Creates a loader theme based on specified colors and symbols.
/// - [copyWith]: Creates a copy of the current theme with optional modifications.

class LoaderTheme {
  final StyleFunction processingStyle;
  final StyleFunction errorStyle;
  final StyleFunction successStyle;

  final List<String> spinners;
  final int interval;

  final String successPrefix;
  final String errorPrefix;

  const LoaderTheme({
    required this.processingStyle,
    required this.errorStyle,
    required this.successStyle,
    required this.spinners,
    required this.interval,
    required this.successPrefix,
    required this.errorPrefix,
  });

  factory LoaderTheme.fromDefault() => LoaderTheme.fromColors(
        ThemeColors.defaultColors,
        ThemeSymbols.defaultSymbols,
      );
  factory LoaderTheme.fromColors(ThemeColors colors, ThemeSymbols symbols) {
    return LoaderTheme(
      processingStyle: (x) => colors.active(x),
      errorStyle: (x) => colors.error(x),
      successStyle: (x) => colors.success(x),
      spinners: symbols.spinners,
      interval: 80,
      successPrefix: symbols.successStep,
      errorPrefix: symbols.error,
    );
  }

  LoaderTheme copyWith({
    StyleFunction? processingStyle,
    StyleFunction? errorStyle,
    StyleFunction? successStyle,
    List<String>? spinners,
    int? interval,
    String? successPrefix,
    String? errorPrefix,
  }) {
    return LoaderTheme(
      processingStyle: processingStyle ?? this.processingStyle,
      errorStyle: errorStyle ?? this.errorStyle,
      successStyle: successStyle ?? this.successStyle,
      spinners: spinners ?? this.spinners,
      interval: interval ?? this.interval,
      successPrefix: successPrefix ?? this.successPrefix,
      errorPrefix: errorPrefix ?? this.errorPrefix,
    );
  }
}
