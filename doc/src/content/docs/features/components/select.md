---
title: Select one
description: A guide in my new Starlight docs site.
---


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
