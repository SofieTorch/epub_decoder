import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:epub_decoder/epub_decoder.dart';

void main() {
  late Epub epub;
  late Epub badFormattedEpub;

  setUp(() {
    epub = Epub.fromFile(File('test/resources/demo.epub'));

    final badFormattedEpubFile = File('test/resources/bad_formatted_demo.epub');
    badFormattedEpub = Epub.fromBytes(badFormattedEpubFile.readAsBytesSync());
  });

  test('''Epub.sections returns each <itemref> from <spine>
  and its relations with another items''', () {
    final expectedSections = [
      Section(
        content: Item(
          id: 'cover',
          href: 'Text/cover.xhtml',
          mediaType: ItemMediaType.xhtml,
          source: epub,
        ),
        readingOrder: 1,
        source: epub,
      ),
      Section(
        content: Item(
          id: 'p001',
          href: 'Text/p001.xhtml',
          mediaType: ItemMediaType.xhtml,
          source: epub,
          mediaOverlay: Item(
            id: 's001',
            href: 'Text/p001.xhtml.smil',
            mediaType: ItemMediaType.mediaOverlay,
            source: epub,
          )..refinements.add(DocumentMetadata(
              property: 'media:duration',
              value: '0:00:53.320',
              refinesTo: 's001',
            )),
        ),
        readingOrder: 2,
        source: epub,
      ),
      Section(
        content: Item(
          id: 'p002',
          href: 'Text/p002.xhtml',
          mediaType: ItemMediaType.xhtml,
          source: epub,
          mediaOverlay: Item(
            id: 's002',
            href: 'Text/p002.xhtml.smil',
            mediaType: ItemMediaType.mediaOverlay,
            source: epub,
          )..refinements.add(DocumentMetadata(
              property: 'media:duration',
              value: '0:00:52.950',
              refinesTo: 's002',
            )),
        ),
        readingOrder: 3,
        source: epub,
      ),
    ];

    final sections = epub.sections;
    expect(sections, equals(expectedSections));
  });

  test('''Epub.items throws error when an item references
  a media overlay that does not exists''', () {
    expect(() => badFormattedEpub.items, throwsUnimplementedError);
  });

  test('''An EPUB with invoked attributes is different from another
      which has not been invoked, even if both are the same EPUB File''', () {
    // Epub to compare, using the same Epub file as [epub]
    final epub2 = Epub.fromFile(File('test/resources/demo.epub'));

    expect(epub, equals(epub2));

    // Invoking epub sections
    epub.sections;
    expect(epub, isNot(equals(epub2)));
  });
}
