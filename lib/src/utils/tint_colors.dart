// ignore: implementation_imports
import 'package:tint/src/helpers.dart';
import 'package:tint/tint.dart';

extension TintColors on String {
  String darkGray() => gray().dim();
  String customColor() => red();

  ///format256(rgbToAnsiCode(133, 38, 255), 5)(this);
}

extension StringColor on String {
  String fg(int color) => format(color, 39)(this);

  String fg256(int color) => format('38;5;$color', 0)(this);
  String bg256(int color) => format('48;5;$color', 0)(this);

  String lightGray() => fg256(252);
  String lightGrayDim() => fg256(243);
}

/// https://codehs.com/uploads/7c2481e9158534231fcb3c9b6003d6b3
// String Function(String) fg(int color) => format(color, 39);
