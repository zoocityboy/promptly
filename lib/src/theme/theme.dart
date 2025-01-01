// ignore_for_file: public_member_api_docs
// ---
// I can't write docs comments for all of [Theme] properties,
// it's too much.
// But I did use expressive names, so it should be good.

import 'package:promptly/promptly.dart';

part 'theme.confirm.dart';
part 'theme.header.dart';
part 'theme.link.dart';
part 'theme.loader.dart';
part 'theme.password.dart';
part 'theme.progress.dart';
part 'theme.prompt.dart';
part 'theme.select.dart';
part 'theme.table.dart';

/// [Function] takes a [String] and returns a [String].
///
/// Used for styling texts in the [Theme].
typedef StyleFunction = String Function(String);

/// The theme to be used by components.
class Theme {
  /// Constructs a new [Theme] with all of it's properties.
  const Theme._({
    required this.spacing,
    required this.colors,
    required this.symbols,
    required this.showActiveCursor,
    required this.confirmTheme,
    required this.promptTheme,
    required this.progressTheme,
    required this.selectTheme,
    required this.linkTheme,
    required this.passwordTheme,
    required this.tableTheme,
    required this.loaderTheme,
    required this.headerTheme,
  });
  final int spacing;
  final bool showActiveCursor;
  final ThemeColors colors;
  final ThemeSymbols symbols;
  final ConfirmTheme confirmTheme;
  final PromptTheme promptTheme;
  final ProgressTheme progressTheme;
  final SelectTheme selectTheme;
  final LinkTheme linkTheme;
  final PasswordTheme passwordTheme;
  final TableTheme tableTheme;
  final LoaderTheme loaderTheme;
  final HeaderTheme headerTheme;

  factory Theme.fromDefault() {
    final colors = ThemeColors.defaultColors;
    const symbols = ThemeSymbols.defaultSymbols;
    return Theme._(
      spacing: 3,
      colors: colors,
      showActiveCursor: false,
      symbols: symbols,
      confirmTheme: ConfirmTheme.fromColors(colors),
      promptTheme: PromptTheme.fromColors(colors),
      progressTheme: ProgressTheme.fromColors(colors),
      selectTheme: SelectTheme.fromColors(colors),
      linkTheme: LinkTheme.fromColors(colors),
      passwordTheme: PasswordTheme.fromColors(colors),
      tableTheme: TableTheme.fromColors(colors),
      loaderTheme: LoaderTheme.fromColors(colors),
      headerTheme: HeaderTheme.fromColors(colors),
    );
  }
  factory Theme.make({required ThemeColors colors, ThemeSymbols? symbols}) {
    return Theme._(
      spacing: 3,
      colors: colors,
      showActiveCursor: false,
      symbols: symbols ?? ThemeSymbols.defaultSymbols,
      confirmTheme: ConfirmTheme.fromColors(colors),
      promptTheme: PromptTheme.fromColors(colors),
      progressTheme: ProgressTheme.fromColors(colors),
      selectTheme: SelectTheme.fromColors(colors),
      linkTheme: LinkTheme.fromColors(colors),
      passwordTheme: PasswordTheme.fromColors(colors),
      tableTheme: TableTheme.fromColors(colors),
      loaderTheme: LoaderTheme.fromColors(colors),
      headerTheme: HeaderTheme.fromColors(colors),
    );
  }

  /// Copy current theme with new properties and create a
  /// new [Theme] from it.
  Theme copyWith({
    int? spacing,
    bool? showActiveCursor,
    ThemeColors? colors,
    ThemeSymbols? symbols,
    ConfirmTheme? confirmTheme,
    PromptTheme? promptTheme,
    ProgressTheme? progressTheme,
    SelectTheme? selectTheme,
    LinkTheme? linkTheme,
    PasswordTheme? passwordTheme,
    TableTheme? tableTheme,
    LoaderTheme? loaderTheme,
    HeaderTheme? headerTheme,
  }) {
    return Theme._(
      spacing: spacing ?? this.spacing,
      colors: colors ?? this.colors,
      symbols: symbols ?? this.symbols,
      showActiveCursor: showActiveCursor ?? this.showActiveCursor,
      confirmTheme: confirmTheme ?? this.confirmTheme,
      promptTheme: promptTheme ?? this.promptTheme,
      progressTheme: progressTheme ?? this.progressTheme,
      selectTheme: selectTheme ?? this.selectTheme,
      linkTheme: linkTheme ?? this.linkTheme,
      passwordTheme: passwordTheme ?? this.passwordTheme,
      tableTheme: tableTheme ?? this.tableTheme,
      loaderTheme: loaderTheme ?? this.loaderTheme,
      headerTheme: headerTheme ?? this.headerTheme,
    );
  }

  /// An alias to [colorfulTheme].
  static Theme defaultTheme = _theme;

  // /// A very colorful theme.
  // static final colorfulTheme = Theme(
  //   spacing: 2,
  //   inputPrefix: '?'.padRight(2).yellow(),
  //   inputSuffix: '›'.padLeft(2).grey(),
  //   successPrefix: '✔'.padRight(2).green(),
  //   successSuffix: '·'.padLeft(2).grey(),
  //   errorPrefix: '✘'.padRight(2).red(),
  //   hiddenPrefix: '****',
  //   messageStyle: (x) => x.bold(),
  //   errorStyle: (x) => x.red(),
  //   hintStyle: (x) => '($x)'.grey(),
  //   valueStyle: (x) => x.green(),
  //   defaultStyle: (x) => x.cyan(),
  //   activeItemPrefix: '❯'.green(),
  //   inactiveItemPrefix: ' ',
  //   activeItemStyle: (x) => x.cyan(),
  //   inactiveItemStyle: (x) => x,
  //   checkedItemPrefix: '✔'.green(),
  //   uncheckedItemPrefix: ' ',
  //   pickedItemPrefix: '❯'.green(),
  //   unpickedItemPrefix: ' ',
  //   showActiveCursor: false,
  //   progressPrefix: '',
  //   progressSuffix: '',
  //   emptyProgress: '░',
  //   filledProgress: '█',
  //   leadingProgress: '█',
  //   emptyProgressStyle: (x) => x,
  //   filledProgressStyle: (x) => x,
  //   leadingProgressStyle: (x) => x,
  //   spinners: '⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'.split(''),
  //   spinningInterval: 80,
  //   linePrefixStyle: (x) => x.gray(),
  // );

  static final _theme = Theme._(
    spacing: 3,
    colors: ThemeColors.defaultColors,
    symbols: ThemeSymbols.defaultSymbols,
    showActiveCursor: false,
    confirmTheme: ConfirmTheme.fromDefault(),
    promptTheme: PromptTheme.fromDefault(),
    progressTheme: ProgressTheme.fromDefault(),
    selectTheme: SelectTheme.fromDefault(),
    linkTheme: LinkTheme.fromDefault(),
    passwordTheme: PasswordTheme.fromDefault(),
    tableTheme: TableTheme.fromDefault(),
    loaderTheme: LoaderTheme.fromDefault(),
    headerTheme: HeaderTheme.fromDefault(),

    ///
    // promptPrefix: '?'.padRight(3).green(),
    // promptSuffix: '›'.padLeft(2).grey(),
    // successPrefix: '◆'.padRight(3).green(),
    // successSuffix: '✔'.padRight(3).green(),
    // successLabelStyle: (p0) => p0.white().onGreen(),
    // successMessageStyle: (p0) => p0.green(),
    // errorPrefix: '■'.padRight(3).red(),
    // hiddenPrefix: '••••',
    // messageStyle: (m) => m.white(),
    // errorStyle: (x) => x.red(),
    // hintStyle: (m) => m.gray(),
    // valueStyle: (x) => x.green().bold(),
    // defaultStyle: (x) => x.cyan(),
    // activeItemPrefix: '❯'.padLeft(3 + 1).brightGreen(),
    // inactiveItemPrefix: ' '.padLeft(3 + 1).green(),
    // activeItemStyle: (m) => m.brightGreen(),
    // inactiveItemStyle: (m) => m.grey(),
    // checkedItemPrefix: '◉'.padLeft(3 + 1).brightGreen(),
    // uncheckedItemPrefix: '◯'.padLeft(3 + 1).green().dim(),
    // pickedItemPrefix: '❯'.green(),
    // unpickedItemPrefix: ' ',
    // showActiveCursor: false,

    // /// Progress
    // progressPrefix: '['.darkGray(),
    // progressSuffix: ']'.darkGray(),
    // emptyProgress: '─',
    // filledProgress: '─'.bold(),
    // leadingProgress: '─'.bold(),
    // emptyProgressStyle: (x) => x.darkGray(),
    // filledProgressStyle: (x) => x.brightGreen(),
    // leadingProgressStyle: (x) => x.green(),

    // ///
    // // spinners: '⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'.split(''),
    // spinners: [
    //   // '⬖',
    //   // '⬘',
    //   // '⬗',
    //   // '⬙',
    //   // '⬖',
    //   // '⬘',
    //   // '⬗',
    //   // '⬙',
    //   // '⬖',
    //   // '⬘',
    //   '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏',
    // ].map((e) => e.padRight(3).green()).toList(),
    // spinningInterval: 80,
    // linePrefixStyle: (p0) => p0.padRight(3).darkGray(),
  );
}

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

  StyleFunction successBlock;
  StyleFunction sectionBlock;

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
    required this.successBlock,
    required this.sectionBlock,
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
    StyleFunction? successBlock,
    StyleFunction? sectionBlock,
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
      successBlock: successBlock ?? this.successBlock,
      sectionBlock: sectionBlock ?? this.sectionBlock,
    );
  }

  static final ThemeColors defaultColors = ThemeColors(
    info: (x) => x.brightBlue(),
    warning: (x) => x.yellow(),
    success: (x) => x.green(),
    error: (x) => x.red(),
    hint: (x) => x.gray(),
    value: (x) => x.brightGreen().bold(),
    text: (x) => x.white(),
    active: (x) => x.brightGreen(),
    inactive: (x) => x.grey(),
    prefix: (x) => x.darkGray(),
    successBlock: (x) => x.onGreen().black(),
    sectionBlock: (x) => x.onBrightBlack().black(),
  );

  static final ThemeColors testColors = ThemeColors(
    info: (x) => x.blue(),
    warning: (x) => x.yellow(),
    success: (x) => x.blue(),
    error: (x) => x.red(),
    hint: (x) => x.gray(),
    value: (x) => x.cyan().bold(),
    text: (x) => x.brightWhite(),
    active: (x) => x.brightMagenta(),
    inactive: (x) => x.grey().dim(),
    prefix: (x) => x.brightCyan(),
    successBlock: (x) => x.onBlue().black(),
    sectionBlock: (x) => x.onBrightBlue().black(),
  );
}

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
  );
}

extension ThemeStyledExtension on Theme {
  String prefixLine(String message) {
    final StringBuffer buffer = StringBuffer();
    buffer.write(colors.prefix(symbols.vLine.padRight(spacing)));
    buffer.write(message);
    return buffer.toString();
  }

  String prefixSectionLine(String message) {
    final StringBuffer buffer = StringBuffer();
    buffer.write(colors.prefix(symbols.vLine.padRight(spacing - 1)));
    buffer.write(message);
    return buffer.toString();
  }

  String prefixHeaderLine(String message) {
    final StringBuffer buffer = StringBuffer();
    buffer.write(colors.prefix(symbols.header.padRight(spacing - 1)));
    buffer.write(message);
    return buffer.toString();
  }

  String prefixError(String message) {
    final StringBuffer buffer = StringBuffer();
    buffer.write(colors.error(symbols.errorStep.padRight(spacing)));
    buffer.write(message);
    return buffer.toString();
  }

  String prefixWarning(String message) {
    final StringBuffer buffer = StringBuffer();
    buffer.write(colors.warning(symbols.warningStep.padRight(spacing)));
    buffer.write(message);
    return buffer.toString();
  }

  String prefixInfo(String message) {
    final StringBuffer buffer = StringBuffer();
    buffer.write(colors.info(symbols.infoStep.padRight(spacing)));
    buffer.write(message);
    return buffer.toString();
  }
}
