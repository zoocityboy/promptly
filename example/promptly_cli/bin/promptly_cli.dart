import 'package:promptly_cli/src/runner.dart';

Future<void> main(List<String> args) async {
  await PromptlyCliRunner().run(args);
}
