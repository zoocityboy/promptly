---
title: Header
description: A guide in my new Starlight docs site.
---

Misto standardniho kodovani vystupu pomoci ANSII znacek pouzijte predefinovanou komponentu `header`

```diff lang="dart"
void main(){
- stdout.writeln("Title ~ My description");
+    header('Title', message: "My description");
+    final name = prompt('Your name');
}
```

```bash title="Output"
┌  Input  Please provide the following information:
│  
?  Your name › 
```
