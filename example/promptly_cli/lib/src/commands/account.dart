import 'package:promptly/promptly.dart';

class AccountCommand extends Command<int> {
  AccountCommand() : super('account', 'Create a new user');

  @override
  Future<int> run() async {
    header(name, message: description);

//     success('''
//   , __                                _
//  /|/                                | |
//   |___/ ,_    __   _  _  _     _ _|_ | |
//   |    /  |  /  _/ |/ |/ |  |/ _|  |/  |   |
//   |       |_/__/   |  |  |_/|__/ |_/|__/ _/|/
//                             /|              /|
//                             |              | ''');

    warning('I will ask you some questions');

    line();
    final username = prompt('What is your name?', validator: IsNotEmptyValidator());
    line();
    final age = prompt('How old are you?',
        validator: CustomStringValidator('This is not a valid value', (value) {
          final x = int.tryParse(value);
          if (x == null) return false;
          return x > 0 && x < 100;
        }));
    line();
    final email = prompt('What is your email?', validator: EmailValidator());
    line();
    final pwd = password(
      'What is your password?',
      confirmPrompt: 'Confirm password',
      confirmation: true,
    );
    line();
    selectOne('Rolde', choices: ['Admin', 'User', 'Guest'], value: 2);

    line();
    selectAny('Choose authorization type', choices: ['Token', 'Basic', 'OAuth']);

    line();
    confirm('Do you accept the terms and conditions?');

    line();
    final p = progress(
      'Uploading user data',
      length: 50,
      hideProgressOnFinish: true,
    );
    for (var i = 0; i < 25; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      p.increase(2);
    }
    p.finish('Data uploaded', 'File is uploaded to the cloud storage.');
    line();
    return finishSuccesfuly('done', message: 'Flow command completed');
  }
}
