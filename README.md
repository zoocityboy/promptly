![promptly](https://raw.githubusercontent.com/zoocityboy/promptly/refs/heads/main/assets/promptly.png "Resoure")

Developed by 🦏 [zoocityboy](https://zoocityboy.github.io/)

[![Pub](https://img.shields.io/pub/v/promptly.svg?style=flat-square)](https://pub.dev/packages/promptly)
[![pub points](https://img.shields.io/pub/points/mason_coder?style=flat-square&color=2E8B57&label=pub%20points)](https://pub.dev/packages/promptly/score)
[![release](https://github.com/zoocityboy/promptly/actions/workflows/release.yaml/badge.svg?style=flat-square)](https://github.com/zoocityboy/promptly/actions/workflows/release.yaml)
[![Coverage](https://raw.githubusercontent.com/zoocityboy/promptly/main/coverage_badge.svg)](https://github.com/zoocityboy/promptly/actions/workflows/pull-request.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg?style=flat-square)](https://opensource.org/licenses/MIT)


![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=flat-square&logo=dart&logoColor=white)

> [!IMPORTANT]
> This project is currently in pre-production. Breaking changes may occur. Use with caution.

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
class MyRunner extends CommandRunner {
  MyRunner(super.executableName, super.description, {super.version, super.theme, super.logLevel, super.printer}) {
    addCommand(TestCommand());
    addCommand(SecondCommand());
    addCommand(ThirdCommand());
    addCommand(ThirdoCommand());
    addCommand(ThirmoCommand());
  }
}
Future<void> main(List<String> args) => MyRunner(
    'promptly',
    'Runner test',
    version: '0.0.1',
    theme: Theme.defaultTheme,
    // printer: defaultPrinter,
  ).safeRun(args);
```



### Components

A collection of customizable interactive command-line components.

The library contains a bunch of command-line components that are easy to use and customizable, including text and password inputs, radio or select inputs, checkbox or multiple select inputs, spinners, and progress bars. Examples for all the available components can be found in the `example` folder, and the [API Documentation](#api-documentation) section will cover all about them.

As an overview, you can make a `Select` component like this.

```dart
final languages = ['Rust', 'Dart', 'TypeScript'];
final selection = selectOne<String>(
  'Your favorite programming language',
  options: languages,

);

print('${languages[selection]}');
```

It will result in something like this,

![Demo](https://raw.githubusercontent.com/zoocityboy/promptly/refs/heads/main/assets/demo.gif)

<br>

## Installation

Install the latest version of Promptly as a dependency as shown in [pub.dev](https://pub.dev/packages/promptly).

<br>

## API Documentation

### Components

These are the snippets of components with their properties and arguments. Check the [pub documentation](https://pub.dev/documentation/promptly/latest/) to get to know more about them in detail.

<br>
## License

This project is licensed under the [MIT License](LICENSE) as provided in the original repository.