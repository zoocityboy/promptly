// ignore_for_file: public_member_api_docs
// ---
// I can't write docs comments for all of [Theme] properties,
// it's too much.
// But I did use expressive names, so it should be good.

import 'package:promptly/promptly.dart';
import 'package:promptly/src/utils/string_buffer.dart';

part 'theme._colors.dart';
part 'theme._symbols.dart';
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
    required this.selectTableTheme,
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
  final SelectTableTheme selectTableTheme;
  final TableTheme tableTheme;
  final LoaderTheme loaderTheme;
  final HeaderTheme headerTheme;

  factory Theme.fromDefault() {
    final colors = ThemeColors.defaultColors;
    const useSymbols = ThemeSymbols.defaultSymbols;
    return Theme._(
      spacing: 3,
      colors: colors,
      showActiveCursor: false,
      symbols: useSymbols,
      confirmTheme: ConfirmTheme.fromColors(colors, useSymbols),
      promptTheme: PromptTheme.fromColors(colors, useSymbols),
      progressTheme: ProgressTheme.fromColors(colors),
      selectTheme: SelectTheme.fromColors(colors),
      linkTheme: LinkTheme.fromColors(colors),
      passwordTheme: PasswordTheme.fromColors(colors),
      selectTableTheme: SelectTableTheme.fromColors(colors),
      tableTheme: TableTheme.fromColors(colors),
      loaderTheme: LoaderTheme.fromColors(colors, useSymbols),
      headerTheme: HeaderTheme.fromColors(colors),
    );
  }
  factory Theme.make({required ThemeColors colors, ThemeSymbols? symbols}) {
    final useSymbols = symbols ?? ThemeSymbols.defaultSymbols;
    return Theme._(
      spacing: 3,
      colors: colors,
      showActiveCursor: false,
      symbols: useSymbols,
      confirmTheme: ConfirmTheme.fromColors(colors, useSymbols),
      promptTheme: PromptTheme.fromColors(colors, useSymbols),
      progressTheme: ProgressTheme.fromColors(colors),
      selectTheme: SelectTheme.fromColors(colors),
      linkTheme: LinkTheme.fromColors(colors),
      passwordTheme: PasswordTheme.fromColors(colors),
      selectTableTheme: SelectTableTheme.fromColors(colors),
      tableTheme: TableTheme.fromColors(colors),
      loaderTheme: LoaderTheme.fromColors(colors, useSymbols),
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
    SelectTableTheme? selectTableTheme,
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
      selectTableTheme: selectTableTheme ?? this.selectTableTheme,
      tableTheme: tableTheme ?? this.tableTheme,
      loaderTheme: loaderTheme ?? this.loaderTheme,
      headerTheme: headerTheme ?? this.headerTheme,
    );
  }

  /// An alias to [colorfulTheme].
  static Theme defaultTheme = _theme;
  static final _theme = Theme._(
    spacing: 2,
    colors: ThemeColors.defaultColors,
    symbols: ThemeSymbols.defaultSymbols,
    showActiveCursor: false,
    confirmTheme: ConfirmTheme.fromDefault(),
    promptTheme: PromptTheme.fromDefault(),
    progressTheme: ProgressTheme.fromDefault(),
    selectTheme: SelectTheme.fromDefault(),
    linkTheme: LinkTheme.fromDefault(),
    passwordTheme: PasswordTheme.fromDefault(),
    selectTableTheme: SelectTableTheme.fromDefault(),
    loaderTheme: LoaderTheme.fromDefault(),
    headerTheme: HeaderTheme.fromDefault(),
    tableTheme: TableTheme.fromDefault(),
  );
  static Theme astroTheme = _astro;
  static final _astro = Theme._(
    spacing: 3,
    colors: ThemeColors.defaultColors,
    symbols: ThemeSymbols.defaultSymbols.copyWith(
      header: '',
      vLine: '',
      section: '',
      footer: '',
    ),
    showActiveCursor: false,
    confirmTheme: ConfirmTheme.fromDefault(),
    promptTheme: PromptTheme.fromDefault(),
    progressTheme: ProgressTheme.fromDefault(),
    selectTheme: SelectTheme.fromDefault(),
    linkTheme: LinkTheme.fromDefault(),
    passwordTheme: PasswordTheme.fromDefault(),
    selectTableTheme: SelectTableTheme.fromDefault(),
    loaderTheme: LoaderTheme.fromDefault(),
    headerTheme: HeaderTheme.fromDefault(),
    tableTheme: TableTheme.fromDefault(),
  );
}

extension ThemeStyledExtension on Theme {
  String prefixRun(String message) {
    final StringBuffer buffer = StringBuffer();
    // buffer.write(colors.active('?'.padRight(spacing)));
    buffer.write(colors.prefix('❯'));
    buffer.write(colors.success('❯').dim());
    // buffer.write(colors.success('❯'));
    buffer.write(colors.success('\$'));

    buffer.write(' ');
    buffer.write(message);
    return buffer.toString();
  }

  String prefixLine(String message, {StyleFunction? style}) {
    final StringBuffer buffer = StringBuffer();
    buffer.withPrefix((style ?? colors.prefix)(symbols.vLine), message);
    return buffer.toString();
  }

  String prefixSectionLine(String message) {
    final StringBuffer buffer = StringBuffer();
    buffer.withPrefix(colors.prefix(symbols.vLine), message, spacing: spacing - 1);
    return buffer.toString();
  }

  String prefixHeaderLine(String message) {
    final StringBuffer buffer = StringBuffer();
    buffer.withPrefix(colors.prefix(symbols.header), message, spacing: spacing - 1);
    return buffer.toString();
  }

  String prefixError(String message) {
    final StringBuffer buffer = StringBuffer();
    buffer.withPrefix(colors.prefix(symbols.errorStep), message);
    return buffer.toString();
  }

  String prefixWarning(String message) {
    final StringBuffer buffer = StringBuffer();
    buffer.withPrefix(colors.prefix(symbols.warningStep), message);
    return buffer.toString();
  }

  String prefixInfo(String message) {
    final StringBuffer buffer = StringBuffer();
    buffer.withPrefix(colors.prefix(symbols.infoStep), message);
    return buffer.toString();
  }
}
