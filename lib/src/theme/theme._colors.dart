// ignore_for_file: public_member_api_docs
// ---
// I can't write docs comments for all of [Theme] properties,
// it's too much.
// But I did use expressive names, so it should be good.

part of 'theme.dart';

class ThemeColors {
  StyleFunction info;
  StyleFunction warning;
  StyleFunction success;
  StyleFunction error;
  StyleFunction hint;
  StyleFunction value;
  StyleFunction text;
  StyleFunction active;
  StyleFunction inactive;
  StyleFunction prefix;

  ThemeColors({
    required this.info,
    required this.warning,
    required this.success,
    required this.error,
    required this.hint,
    required this.value,
    required this.text,
    required this.active,
    required this.inactive,
    required this.prefix,
  });

  ThemeColors copyWith({
    StyleFunction? info,
    StyleFunction? warning,
    StyleFunction? success,
    StyleFunction? error,
    StyleFunction? hint,
    StyleFunction? value,
    StyleFunction? text,
    StyleFunction? active,
    StyleFunction? inactive,
    StyleFunction? prefix,
  }) {
    return ThemeColors(
      info: info ?? this.info,
      warning: warning ?? this.warning,
      success: success ?? this.success,
      error: error ?? this.error,
      hint: hint ?? this.hint,
      value: value ?? this.value,
      text: text ?? this.text,
      active: active ?? this.active,
      inactive: inactive ?? this.inactive,
      prefix: prefix ?? this.prefix,
    );
  }

  static final ThemeColors defaultColors = ThemeColors(
    info: (x) => x.white(),
    warning: (x) => x.yellow(),
    success: (x) => x.green(),
    error: (x) => x.red(),
    hint: (x) => x.lightGrayDim(),
    value: (x) => x.green().bold(),
    text: (x) => x.lightGray(),
    active: (x) => x.brightGreen(),
    inactive: (x) => x.grey(),
    prefix: (x) => x.darkGray(),
  );

  static final ThemeColors testColors = ThemeColors(
    info: (x) => x.blue(),
    warning: (x) => x.yellow(),
    success: (x) => x.blue(),
    error: (x) => x.red(),
    hint: (x) => x.gray(),
    value: (x) => x.cyan().bold(),
    text: (x) => x.brightWhite(),
    active: (x) => x.brightGreen(),
    inactive: (x) => x.grey().dim(),
    prefix: (x) => x.brightCyan(),
  );
}
