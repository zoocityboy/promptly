// ignore_for_file: public_member_api_docs
// ---
// I can't write docs comments for all of [Theme] properties,
// it's too much.
// But I did use expressive names, so it should be good.
part of 'theme.dart';

class ThemeSymbols {
  const ThemeSymbols({
    required this.header,
    required this.vLine,
    required this.section,
    required this.footer,
    required this.hLine,
    required this.step,
    required this.successStep,
    required this.errorStep,
    required this.activeStep,
    required this.warningStep,
    required this.infoStep,
    required this.spinners,
  });
  final String header;
  final String vLine;
  final String section;
  final String footer;
  final String hLine;

  final String step;
  final String successStep;
  final String errorStep;
  final String activeStep;
  final String warningStep;
  final String infoStep;
  final List<String> spinners;

  ThemeSymbols copyWith({
    String? header,
    String? vLine,
    String? section,
    String? footer,
    String? hLine,
    String? step,
    String? successStep,
    String? errorStep,
    String? activeStep,
    String? warningStep,
    String? infoStep,
    List<String>? spinners,
  }) {
    return ThemeSymbols(
      header: header ?? this.header,
      vLine: vLine ?? this.vLine,
      section: section ?? this.section,
      footer: footer ?? this.footer,
      hLine: hLine ?? this.hLine,
      step: step ?? this.step,
      successStep: successStep ?? this.successStep,
      errorStep: errorStep ?? this.errorStep,
      activeStep: activeStep ?? this.activeStep,
      warningStep: warningStep ?? this.warningStep,
      infoStep: infoStep ?? this.infoStep,
      spinners: spinners ?? this.spinners,
    );
  }

  static const ThemeSymbols defaultSymbols = ThemeSymbols(
    header: '┌',
    vLine: '│',
    section: '├',
    footer: '└',
    hLine: '─',
    step: '◇',
    successStep: '◆',
    errorStep: '■',
    activeStep: '▹',
    warningStep: '•',
    infoStep: 'ℹ',
    spinners: ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'],
  );
}
