---
title: Password
description: A guide in my new Starlight docs site.
---

A password component behaves pretty much the same as an input component, but the user input will be hidden and by default, it has a repeat password validator that checks if two password inputs are the same or not.

```dart
final value = password(
  prompt: 'Password',
  confirmation: true, // optional and will be false by default
  confirmPrompt: 'Repeat password', // optional
  confirmError: 'Passwords do not match' // optional
);
```
