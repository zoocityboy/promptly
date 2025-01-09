import 'package:promptly/promptly.dart';
import 'package:promptly_cli/src/runner.dart';

Future<void> main(List<String> args) async {
  await flushThenExit(await PromptlyCliRunner().run(args));
}
