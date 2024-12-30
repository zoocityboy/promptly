import 'package:zoo_console/zoo_console.dart';

const earlyPresidents = [
  [
    1,
    'April 30, 1789 - March 4, 1797',
    'George Washington',
    'unaffiliated',
  ],
  [
    2,
    'March 4, 1797 - March 4, 1801',
    'John Adams',
    'Federalist',
  ],
  [
    3,
    'March 4, 1801 - March 4, 1809',
    'Thomas Jefferson',
    'Democratic-Republican',
  ],
  [
    4,
    'March 4, 1809 - March 4, 1817',
    'James Madison',
    'Democratic-Republican',
  ],
  [
    5,
    'March 4, 1817 - March 4, 1825',
    'James Monroe',
    'Democratic-Republican',
  ],
];

void main() {
  // final tabled = dartConsole.Table()
  //   ..insertColumn(header: 'Number', alignment: dartConsole.TextAlignment.center)
  //   ..insertColumn(header: 'Presidency', alignment: dartConsole.TextAlignment.right)
  //   ..insertColumn(header: 'President')
  //   ..insertColumn(header: 'Party')
  //   ..insertRows(earlyPresidents)
  //   ..borderStyle = dartConsole.BorderStyle.rounded
  //   ..borderColor = dartConsole.ConsoleColor.brightBlue
  //   ..borderType = dartConsole.BorderType.horizontal
  //   ..headerStyle = dartConsole.FontStyle.bold;
  // console.write(tabled.toString());

  final x = table(
    'Select a row:',
    headers: ['Number', 'Presidency', 'President', 'Party'],
    rows: earlyPresidents,
  );
}