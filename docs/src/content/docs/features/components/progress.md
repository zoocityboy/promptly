---
title: Progress Bar
description: A guide in my new Starlight docs site.
---


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
