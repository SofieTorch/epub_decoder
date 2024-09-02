---
description: Flutter Package to parse EPUB files (EBooks), with support for Media Overlays!
---

# 📑 EPUB Parser for Flutter 📑

![](https://codecov.io/gh/SofieTorch/epub\_decoder/graph/badge.svg?token=0D5LI5EWM6) ![](https://img.shields.io/pub/v/epub\_decoder?color=blue)

{% hint style="info" %}
If you found this package useful, star this repo and drop a like in pub.dev! 🌟
{% endhint %}

### Features

* ✅ Read EPUB from bytes
* ✅ Read EPUB from dart:io file
* ✅ List metadata: title, authors, language, etc. (with support for EPUB2)
* ✅ List resources: audio, images, text, etc.
* ✅ List sections (also commonly named "chapters") in default reading order
* ✅ Get section audio (if exists)
* ✅ Get text-audio synchronization info for each section
* ✅ Get text segment given a time for each section

#### Work in Progress

* [ ] Direct getters for relevant attributes (such as title, authors, etc.)
* [ ] Read navigation definition
* [ ] Support for bindings

### Getting started

Install `epub_decoder` as a dependency.

### Usage

Start by instancing an Epub from an Epub file:

```dart
import 'package:epub_decoder/epub_decoder.dart';

// Creating an EPUB from an asset transformed to bytes
final epubFile = await rootBundle.load('assets/example.epub');
final epub = Epub.fromBytes(epubFile.buffer.asUint8List());
```
