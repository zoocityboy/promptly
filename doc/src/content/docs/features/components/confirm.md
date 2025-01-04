---
title: Confirm
description: A confirm component asks the user for a simple yes or no and will return a boolean accordingly.
# cover: ~/assets/promptly.png
---


```diff lang="dart" title="Change Value"
final answer = confirm(
  'Does it work?',
-  defaultValue: true, // this is optional
+  enterForConfirm: true, // optional and will be false by default
);
```

If `enterForConfirm` is true, the prompt will wait for an <kbd>Enter</kbd> key from the user regardless of the answer.
