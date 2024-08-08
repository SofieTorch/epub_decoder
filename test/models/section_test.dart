import 'dart:io';

import 'package:epub_decoder/epub.dart';
import 'package:epub_decoder/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Epub epub;

  setUp(() {
    epub = Epub.fromFile(File('test/resources/demo.epub'));
  });

  test('Section.hasAudio is false when content has no defined media overlay',
      () {
    final section = Section(
      content: Item(
        id: 'cover',
        href: 'Text/cover.xhtml',
        mediaType: ItemMediaType.xhtml,
        source: epub,
      ),
      readingOrder: 1,
      source: epub,
    );

    expect(section.hasAudio, false);
  });

  test('''Audio related attributes are null or empty
      when there is no audio version''', () {
    final section = Section(
      content: Item(
        id: 'cover',
        href: 'Text/cover.xhtml',
        mediaType: ItemMediaType.xhtml,
        source: epub,
      ),
      readingOrder: 1,
      source: epub,
    );

    expect(section.audio, isNull);
    expect(section.audioDuration, isNull);
    expect(section.smilParallels, isEmpty);
    expect(section.getParallelAtTime(const Duration(seconds: 10)), isNull);
  });

  test('Section.hasAudio is true when content has media overlay', () {
    final section = Section(
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
        ),
      ),
      readingOrder: 2,
      source: epub,
    );

    expect(section.hasAudio, true);
  });

  test('Section.audio returns the expected mp3 as bytes', () {
    final section = Section(
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
        ),
      ),
      readingOrder: 2,
      source: epub,
    );

    final expectedAudio = File('test/resources/p001.mp3');

    expect(section.audio, equals(expectedAudio.readAsBytesSync()));
  });

  test('''Section.audio throws exception
      when the referenced audio file is not found''', () {
    final badFormattedEpub = Epub.fromFile(
      File('test/resources/bad_formatted_demo.epub'),
    );

    final section = Section(
      content: Item(
        id: 'p001',
        href: 'Text/p001.xhtml',
        mediaType: ItemMediaType.xhtml,
        source: badFormattedEpub,
        mediaOverlay: Item(
          id: 's001',
          href: 'Text/p001.xhtml.smil',
          mediaType: ItemMediaType.mediaOverlay,
          source: badFormattedEpub,
        ),
      ),
      readingOrder: 2,
      source: epub,
    );

    expect(
      () => section.audio,
      throwsA(isA<FileSystemException>()),
    );
  });

  test('Section.audioDuration returns duration defined in metadata', () {
    final section = Section(
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
        )..refinements.add(
            DocumentMetadata(
              property: 'media:duration',
              value: '0:00:53.320',
            ),
          ),
      ),
      readingOrder: 2,
      source: epub,
    );

    expect(
      section.audioDuration,
      equals(const Duration(seconds: 53, milliseconds: 320)),
    );
  });

  test('''Section.audioDuration throws error
      when duration is not defined in metadata''', () {
    final section = Section(
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
          )),
      readingOrder: 2,
      source: epub,
    );

    expect(
      () => section.audioDuration,
      throwsStateError,
    );
  });

  test('''Section.getParallelAtTime() returns the
  SmilParallel that matches with the given time''', () {
    final section = Section(
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
        )..refinements.add(
            DocumentMetadata(
              property: 'media:duration',
              value: '0:00:53.320',
            ),
          ),
      ),
      readingOrder: 2,
      source: epub,
    );

    expect(
      section.getParallelAtTime(const Duration(seconds: 10)),
      equals(const SmilParallel(
        id: 'p000004',
        clipBegin: Duration(seconds: 8, milliseconds: 640),
        clipEnd: Duration(seconds: 11, milliseconds: 960),
        textFileName: 'p001.xhtml',
        textId: 'f004',
      )),
    );
  });
}
