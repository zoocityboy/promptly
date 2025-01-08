import 'package:promptly/promptly.dart';

Future<void> main() async {
  header('Multi Loader', message: 'Showcase of multi loader');
  final loaders = MultiLoader();

  final horse = loaders.add(
    Loader(
      prompt: 'Processing horse',
    ),
  );

  final rabbit = loaders.add(
    Loader(
      prompt: 'Processing rabbit',
    ),
  );

  final turtle = loaders.add(
    Loader(
      prompt: 'Processing turtle',
    ),
  );

  await Future.delayed(const Duration(seconds: 1));
  horse.success('Done');

  await Future.delayed(const Duration(seconds: 1));
  rabbit.failed('Failed');

  await Future.delayed(const Duration(seconds: 2));
  turtle.success('Done');
  line();
}
