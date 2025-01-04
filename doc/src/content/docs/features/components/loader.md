---
title: Loader
description: A spinner will show a spinning indicator until the user calls it's `success` method. When it's done, it shows the icon given in place of the spinner.
---

A spinner will show a spinning indicator until the user calls it's `done` method. When it's done, it shows the icon given in place of the spinner.

### Single

```dart showLineNumbers
final gift = loader('Loadingn data');

await Future.delayed(const Duration(seconds: 5));
gift.success('Data loaded');
```

### Task

You can run async operation inside `task`

```dart {3-9} frame="code" showLineNumbers
// this is just a sample, non-producton code example
Future<void> main() async {
  header('Run', message: 'async operation');
  await task(
    'My task',
    task: (value) async {
      await Future.delayed(const Duration(seconds: 2));
      throw Exception('Not found');
    },
  );
  failure('My task failed');
}
```

```ansi title="otput" frame="none" showLineNumbers=false
┌  Run  async operation
│  
■  Exception: Not found                                    
│                                                          
└❯❯❯  My task failed   
```

```bash withOutput
> pwd

/usr/home/boba-tan/programming
```