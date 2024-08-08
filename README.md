<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->
<h1 align="center">
📑  EPUB Parser for Flutter  📑
<br/>
<a href="https://codecov.io/gh/SofieTorch/epub_decoder" > 
 <img src="https://codecov.io/gh/SofieTorch/epub_decoder/graph/badge.svg?token=0D5LI5EWM6"/> 
 </a>
 <img alt="Pub Version" src="https://img.shields.io/pub/v/epub_decoder?color=blue&link=https%3A%2F%2Fpub.dev%2Fpackages%2Fepub_decoder">

</h1>

Flutter Package to parse EPUB files (EBooks), with support for Media Overlays!

> If you found this package useful, star this repo and drop a like in pub.dev! 🌟.

## Features

✅ Read EPUB from bytes  
✅ Read EPUB from dart:io file  
✅ List metadata: title, authors, language, etc. (with support for EPUB2)  
✅ List resources: audio, images, text, etc.  
✅ List sections (also commonly named "chapters") in default reading order  
✅ Get section audio (if exists)  
✅ Get text-audio synchronization info for each section  
✅ Get text segment given a time for each section

### Work in progress

- [ ] Direct getters for relevant attributes (such as title, authors, etc.)
- [ ] Read navigation definition
- [ ] Support for bindings

## Getting started

Install `epub_decoder` as a dependency.

## Usage

Start by instancing an Epub from an Epub file:

```dart
import 'package:epub_decoder/epub_decoder.dart';

// Creating an EPUB from an asset transformed to bytes
final epubFile = await rootBundle.load('assets/example.epub');
final epub = Epub.fromBytes(epubFile.buffer.asUint8List());
```

And then, access its properties:

- **Retrieving Metadata:** `epub.metadata`

    <details>
    <summary>↘ Expand for example result</summary>
    
    Please note that this is actually a `List<Metadata>` object (here you are seeing its `.toString()` representation).

  ```
  [
      {
          key: identifier,
          id: pubID,
          value: urn:uuid:8a5d2330-08d6-405b-a359-e6862b48ea4d,
          refinements: [
              {
                  id: null,
                  value: uuid,
                  refinesTo: pubID,
                  property: identifier-type,
                  schema: null,
                  name: null,
                  content: null,
                  refinements: []
              }
          ]
      },
      {
          key: title,
          id: title,
          value: [DEMO] How To Create EPUB 3 Read Aloud eBooks,
          refinements: []
      },
      {
          key: creator,
          id: aut,
          value: Alberto Pettarin,
          refinements: [
              {
                  id: null,
                  value: aut,
                  refinesTo: aut,
                  property: role,
                  schema: null,
                  name: null,
                  content: null,
                  refinements: []
              },
              {
                  id: null,
                  value: Pettarin, Alberto,
                  refinesTo: aut,
                  property: file-as,
                  schema: null,
                  name: null,
                  content: null,
                  refinements: []
              }
          ]
      },
      {
          id: null,
          value: portrait,
          refinesTo: null,
          property: rendition:orientation,
          schema: null,
          name: null, content: null, refinements: []
      },
      {
          id: null,
          value: 0:00:53.320,
          refinesTo: s001,
          property: media:duration,
          schema: null,
          name: null,
          content: null,
          refinements: []
      }
  ]

  ```

    </details>

- **Retrieving resources/items:** `epub.items`

    <details>
    <summary>↘ Expand for example result</summary>
    
    Please note that this is actually a `List<Item>` object (here you are seeing its `.toString()` representation).

  ```
  [
      {
          id: toc,
          href: Text/toc.xhtml,
          mediaType: ItemMediaType.xhtml,
          properties: [ItemProperty.nav],
          mediaOverlay: null,
          refinements: []
      },
      {
          id: cover,
          href: Text/cover.xhtml,
          mediaType: ItemMediaType.xhtml,
          properties: [],
          mediaOverlay: null,
          refinements: []
      },
      {
          id: c001,
          href: Styles/style.css,
          mediaType: ItemMediaType.css,
          properties: [],
          mediaOverlay: null,
          refinements: []
      },
      {
          id: p001,
          href: Text/p001.xhtml,
          mediaType: ItemMediaType.xhtml,
          properties: [],
          mediaOverlay: {
              id: s001,
              href: Text/p001.xhtml.smil,
              mediaType: ItemMediaType.mediaOverlay,
              properties: [],
              mediaOverlay: null,
              refinements: [{
                  id: null,
                  value: 0:00:53.320,
                  refinesTo: s001,
                  property: media:duration,
                  schema: null,
                  name: null,
                  content: null,
                  refinements: []
              }]
          },
          refinements: []
      }
  ]

  ```

    </details>

- **Retrieving reading sections:** `epub.sections`

    <details>
    <summary>↘ Expand for example result</summary>
    
    Please note that this is actually a `List<Section>` object (here you are seeing its `.toString()` representation).

  ```
  [
      {
          content: {
              id: cover,
              href: Text/cover.xhtml,
              mediaType: ItemMediaType.xhtml,
              properties: [],
              mediaOverlay: null,
              refinements: []
          },
          readingOrder: 1,
          audioDuration: null,
          smilParallels: []
      },
      {
          content: {
              id: p001,
              href: Text/p001.xhtml,
              mediaType: ItemMediaType.xhtml,
              properties: [],
              mediaOverlay: {
                  id: s001,
                  href: Text/p001.xhtml.smil,
                  mediaType: ItemMediaType.mediaOverlay,
                  properties: [],
                  mediaOverlay: null,
                  refinements: [{
                      id: null,
                      value: 0:00:53.320,
                      refinesTo: s001,
                      property: media:duration,
                      schema: null,
                      name: null,
                      content: null,
                      refinements: []
                  }]
              },
              refinements: []
          },
          readingOrder: 2,
          audioDuration: 0:00:53.320000,
          smilParallels: [
              {
                  id: p000001,
                  clipBegin: 0:00:00.000000,
                  clipEnd: 0:00:02.680000,
                  textFileName: p001.xhtml,
                  textId: f001
              },
              {
                  id: p000002,
                  clipBegin: 0:00:02.680000,
                  clipEnd: 0:00:05.480000,
                  textFileName: p001.xhtml,
                  textId: f002
              },
              {
                  id: p000003,
                  clipBegin: 0:00:05.480000,
                  clipEnd: 0:00:08.640000,
                  textFileName: p001.xhtml,
                  textId: f003
              },
              {
                  id: p000004,
                  clipBegin: 0:00:08.640000,
                  clipEnd: 0:00:11.960000,
                  textFileName: p001.xhtml,
                  textId: f004
              }
          ]
      }
  ]

  ```

    </details>

- **Retrieving text segment from a certain time**

  ```dart
  final section = epub.sections[1];
  final targetTime = Duration(seconds: 10);
  print(section.getParallelAtTime(targetTime)));
  ```

    <details>
    <summary>↘ Expand for example result</summary>
    
    Please note that this is actually a `SmilParallel` object (here you are seeing its `.toString()` representation).

  ```
  {
      id: p000004,
      clipBegin: 0:00:08.640000,
      clipEnd: 0:00:11.960000,
      textFileName: p001.xhtml,
      textId: f004
  }

  ```

    </details>

## Additional information

To understand EPUB3 specification and therefore plan the structure of this package, the following page was taken as reference: [Package and Metadata | EPUB3 Best Practices](https://www.oreilly.com/library/view/epub-3-best/9781449329129/ch01.html).

However, you can learn more about in the [EPUB3 official specification documentation](https://www.w3.org/TR/epub-33) and [EPUB Media Overlays documentation](https://www.oreilly.com/library/view/epub-3-best/9781449329129/ch01.html).

### Contributing

- If you have any request or find some bug, feel free to open a new issue.
- if you want to contribute, open a new issue with your proposal and if approved, continue with a pull request 😉.
