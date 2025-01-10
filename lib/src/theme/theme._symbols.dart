// ignore_for_file: public_member_api_docs
// ---
// I can't write docs comments for all of [Theme] properties,
// it's too much.
// But I did use expressive names, so it should be good.
part of 'theme.dart';

/// A class that holds various symbols used in the theme.
///
/// The [ThemeSymbols] class provides a set of symbols that can be used
/// throughout the application for consistent theming. It includes symbols
/// for headers, vertical lines, sections, footers, horizontal lines, steps,
/// and various states of steps such as success, error, active, warning, and info.
/// Additionally, it includes a list of spinner symbols.
///
/// The class also provides a `copyWith` method to create a copy of an instance
/// with some properties replaced by new values.
///
/// Example usage:
/// ```dart
/// final themeSymbols = ThemeSymbols.defaultSymbols;
/// final customSymbols = themeSymbols.copyWith(header: '╔');
/// ```
///
/// Properties:
/// - `header`: Symbol for the header.
/// - `vLine`: Symbol for the vertical line.
/// - `section`: Symbol for the section.
/// - `footer`: Symbol for the footer.
/// - `hLine`: Symbol for the horizontal line.
/// - `step`: Symbol for a step.
/// - `successStep`: Symbol for a successful step.
/// - `errorStep`: Symbol for an error step.
/// - `activeStep`: Symbol for an active step.
/// - `warningStep`: Symbol for a warning step.
/// - `infoStep`: Symbol for an info step.
/// - `spinners`: List of symbols for spinners.
///
/// Static Properties:
/// - `defaultSymbols`: A default instance of [ThemeSymbols] with predefined symbols.

class ThemeSymbols {
  const ThemeSymbols({
    required this.header,
    required this.vLine,
    required this.section,
    required this.footer,
    required this.step,
    required this.successStep,
    required this.error,
    required this.activeStep,
    required this.dotStep,
    required this.infoStep,
    required this.spinners,
    required this.success,
    required this.select,
    required this.unselect,
    required this.checked,
    required this.unchecked,
  });
  final String header;
  final String vLine;
  final String section;
  final String footer;

  final String step;
  final String successStep;
  final String error;
  final String activeStep;
  final String dotStep;
  final String infoStep;
  final List<String> spinners;
  final String success;
  final String select;
  final String unselect;
  final String checked;
  final String unchecked;

  ThemeSymbols copyWith({
    String? header,
    String? vLine,
    String? section,
    String? footer,
    String? step,
    String? successStep,
    String? errorStep,
    String? activeStep,
    String? dotStep,
    String? infoStep,
    List<String>? spinners,
    String? success,
    String? select,
    String? unselect,
    String? checked,
    String? unchecked,
  }) {
    return ThemeSymbols(
      header: header ?? this.header,
      vLine: vLine ?? this.vLine,
      section: section ?? this.section,
      footer: footer ?? this.footer,
      step: step ?? this.step,
      successStep: successStep ?? this.successStep,
      error: errorStep ?? error,
      activeStep: activeStep ?? this.activeStep,
      dotStep: dotStep ?? this.dotStep,
      infoStep: infoStep ?? this.infoStep,
      spinners: spinners ?? this.spinners,
      success: success ?? this.success,
      select: select ?? this.select,
      unselect: unselect ?? this.unselect,
      checked: checked ?? this.checked,
      unchecked: unchecked ?? this.unchecked,
    );
  }

  static const ThemeSymbols defaultSymbols = ThemeSymbols(
    header: '┌',
    vLine: '│',
    section: '├',
    footer: '└',

    /// Steps
    step: '◇',
    successStep: '◆',
    activeStep: '▹',
    dotStep: '•',
    infoStep: 'ℹ',

    // Actions
    select: '❯',
    unselect: ' ',
    checked: '◉',
    unchecked: '◯',
    spinners: ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'],
    

    //
    error: '■',
    success: '✔',
  );
}
