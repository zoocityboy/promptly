import 'package:zoo_console/src/components/components.dart';
import 'package:zoo_console/src/console.dart';

Future<void> main() async {
  final bars = MultiProgress();
  ZooConsole();
  const length = 1000;
  // final theme = Theme.basicTheme.copyWith(
  //   emptyProgress: '-',
  //   progressPrefix: '',
  //   progressSuffix: '',
  //   emptyProgressStyle: (x) => x.darkGray(),
  //   filledProgressStyle: (x) => x.green(),
  //   leadingProgressStyle: (x) => x.cyan(),
  // );
  final theme = ZooConsole.instance.theme;

  final p1 = bars.add(
    Progress.withTheme(
      'Downloading',
      size: 0.5,
      theme: theme,
      length: length,
    ),
  );

  final p2 = bars.add(
    Progress.withTheme(
      'Downloading',
      size: 0.5,
      theme: theme,
      length: length,
    ),
  );

  final p3 = bars.add(
    Progress.withTheme(
      'Downloading',
      size: 0.5,
      theme: theme,
      length: length,
    ),
  );

  await Future.delayed(const Duration(seconds: 1));

  for (var i = 0; i < 500; i++) {
    await Future.delayed(const Duration(milliseconds: 2));
    p3.increase(1);
  }

  for (var i = 0; i < 500; i++) {
    await Future.delayed(const Duration(milliseconds: 1));
    p2.increase(1);
    p3.increase(1);
  }

  await Future.delayed(const Duration(seconds: 2));

  for (var i = 0; i < 500; i++) {
    await Future.delayed(const Duration(milliseconds: 2));
    p2.increase(1);
  }

  for (var i = 0; i < 500; i++) {
    await Future.delayed(const Duration(milliseconds: 3));
    p1.increase(2);
  }

  p1.done();
  p2.done();
  p3.done();
}
