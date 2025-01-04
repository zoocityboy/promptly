![alt text](./assets/promptly.png "Resoure")

Developed by 🦏 [zoocityboy][zoocityboy_link]
# Promptly 

> Create a terminal apps great again!

[![Pub](https://img.shields.io/pub/v/promptly.svg?style=flat-square)](https://pub.dev/packages/promptly)
[![pub points](https://img.shields.io/pub/points/mason_coder?style=flat-square&color=2E8B57&label=pub%20points)](https://pub.dev/packages/promptly/score)
[![release](https://github.com/zoocityboy/promptly/actions/workflows/release.yaml/badge.svg?style=flat-square)](https://github.com/zoocityboy/promptly/actions/workflows/release.yaml)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg?style=flat-square)](https://opensource.org/licenses/MIT)


![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=flat-square&logo=dart&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=flat-square&logo=githubactions&logoColor=white)

[Documentation](https://zoocityboy.github.io/promptly/)

## Features

- [x] Argument parser
- [x] CommandRunner, Command definition
- [x] Command flow [components](#components)
- [x] Process helpers (executors) 
- [x] Tracing, Logging
- [x] Themable 

### Command Runner

A simple way to write command-line applications in Dart with styling and command loading capabilities.

```dart
Future<void> main(List<String> args) async {
  (await Promptly.init('app','MyAppDescription', theme: Theme.make(Theme.defaultColors)))
    ..addCommand(TestCommand())
    ..addCommand(SecondCommand())
    ..addCommand(ThirdCommand());
  .run(args);
}
```

### Components

A collection of customizable interactive command-line components.

The library contains a bunch of command-line components that are easy to use and customizable, including text and password inputs, radio or select inputs, checkbox or multiple select inputs, spinners, and progress bars. Examples for all the available components can be found in the `example` folder, and the [API Documentation](#api-documentation) section will cover all about them.

As an overview, you can make a `Select` component like this.

```dart
final languages = ['Rust', 'Dart', 'TypeScript'];
final selection = select<String>(
  'Your favorite programming language',
  options: languages,

);

print('${languages[selection]}');
```

It will result in something like this,

<!-- <img src="https://i.imgur.com/boGsIn4.png" /> -->

<br>

## Installation

Install the latest version of interact as a dependency as shown in [pub.dev](https://pub.dev/packages/promptly).

<br>

## API Documentation

### Components

These are the snippets of components with their properties and arguments. Check the [pub documentation](https://pub.dev/documentation/promptly/latest/) to get to know more about them in detail.

<br>

#### Confirm Component

A confirm component asks the user for a simple yes or no and will return a boolean accordingly.

```dart
final answer = confirm(
  'Does it work?',
  defaultValue: true, // this is optional
  enterForConfirm: true, // optional and will be false by default
);
```

If `enterForConfirm` is true, the prompt will wait for an <kbd>Enter</kbd> key from the user regardless of the answer.

<br>

#### Input Component

An input component asks the user for a string that could be validated.

```dart
final email = prompt<String>(
  prompt: 'Your email',
  defaultValue: '', // optional, will provide the user as a hint
  initialText: '', // optional, will be autofilled in the input
  validator: EmailValidator()
);
```
You can use predefined validators build-in [Promptly] or create a custom Validators by extending `Validator<T>` class
The message passed in the `ValidationError` exception will be shown as an error until the validator returns true.

<br>

#### Password Component

A password component behaves pretty much the same as an input component, but the user input will be hidden and by default, it has a repeat password validator that checks if two password inputs are the same or not.

```dart
final value = password(
  prompt: 'Password',
  confirmation: true, // optional and will be false by default
  confirmPrompt: 'Repeat password', // optional
  confirmError: 'Passwords do not match' // optional
);
```

<br>

#### Select Component

A select component asks the user to choose between the options supplied and the index of the chosen option will be returned.

```dart
final languages = ['Rust', 'Dart', 'TypeScript'];

final selection = select<String>(
  prompt: 'Your favorite programming language',
  options: languages,
  defaultValue: languages[2], // optional, will be 0 by default
);
```


```dart
/// Custom lang class
class Lang{
  const Lang(this.name, this.code)
  final name;
  final code;

  String get display => '$name ($code)';
}

// available choices
final languages = [Lang('English','en'),Lang('Czech','cs')];
final selection = select<Lang>(
  prompt: 'Your favorite language',
  options: languages,
  defaultValue: languages[2],
  display:(value)=> value.display,
);
```

<br>

#### MultiSelect Component

A multi-select component asks the user for multiple options check by using the <kbd>SpaceBar</kbd>. Similarly, the multi-select component will return a list of selected indexes.

```dart
final options = ['A', 'B', 'C'];
final answers = multiSelect<String>(
  prompt: 'Let me know your answers',
  options: options,
  defaults: [options[0]], // optional, will be all false by default
);
```


```dart
class Lang{
  const Lang(this.name, this.code)
  final name;
  final code;

  String get display => '$name ($code)';
}
final languages = [Lang('English','en'),Lang('Czech','cs')];

final selection = multiSelect<Lang>(
  prompt: 'Your favorite language',
  options: languages,
  defaultValue: [languages[2]],
  display:(value)=> value.display,
);
```


<br>

#### Loader and MultiLoader Components

A spinner will show a spinning indicator until the user calls it's `done` method. When it's done, it shows the icon given in place of the spinner.

```dart
final gift = loader('Loadingn data');

await Future.delayed(const Duration(seconds: 5));
gift.success('Data loaded');
```

Using multiple spinners at once is a common practice, but because of the way the library renders things, it's not possible to have multiple them normally. It will break the rendering process of all components.

```dart
final spinners = MultiSpinner();

final horse = spinners.add(Spinner(
  icon: '🐴',
  rightPrompt: (state) => switch (state) {
    SpinnerStateType.inProgress => 'Processing...',
    SpinnerStateType.done => 'Done!',
    SpinnerStateType.failed => 'Failed!',
  },
)); // notice how you don't need to call the `.interact()` function

await Future.delayed(const Duration(seconds: 5));
horse.done();
```

Now you can have multiple of them without breaking things.

<br>

#### Progress and MultiProgress Components

A progress component shows a progress bar.

```dart
final progress = Progress(
  length: 1000, // required, the length of the progress to use
  size: 0.5, // optional, will be 1 by default
  rightPrompt: (current) => ' ${current.toString().padLeft(3)}/$length',
).interact();

for (var i = 0; i < 500; i++) {
  await Future.delayed(const Duration(milliseconds: 5));
  progress.increase(2);
}

progress.done();
```

The `size` is the multiplier for the rendered progress bar and it will be 1 by default. `0.5` means the rendered progress bar will be half the width of the terminal.

A `MultiProgress` does pretty much the same as what `MultiSpinner` did for spinners.

```dart
final bars = MultiProgress();

final p1 = bars.add(Progress(
  length: 100,
  rightPrompt: (current) => ' ${current.toString().padLeft(3)}/$length',
)); // notice how you don't need to call the `.interact()` function

for (var i = 0; i < 500; i++) {
  await Future.delayed(const Duration(milliseconds: 5));
  p1.increase(2);
}

p1.done();
```

<br>
## License

This project is licensed under the [MIT License](LICENSE) as provided in the original repository.