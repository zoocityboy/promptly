---
title: Select multiple
description: A guide in my new Starlight docs site.
---

A multi-select component asks the user for multiple options check by using the <kbd>SpaceBar</kbd>. Similarly, the multi-select component will return a list of selected indexes.

### Select options

```dart
final options = ['A', 'B', 'C'];
final answers = multiSelect<String>(
  prompt: 'Let me know your answers',
  options: options,
  defaults: [options[0]], // optional, will be all false by default
);
```
### Strong type 

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
