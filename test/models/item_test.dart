import 'dart:io';

import 'package:epub_decoder/epub.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:epub_decoder/models/models.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

import '../mocks/epub.mock.dart';

Map<XmlElement, dynamic> _getParameterizedCases(
  String xmlFilePath,
  String xmlXpath,
  List<dynamic> expectedValues,
) {
  final xmlFile = File(xmlFilePath);
  final xmlDocument = XmlDocument.parse(xmlFile.readAsStringSync());
  final metadata = xmlDocument.xpath(xmlXpath).first;
  final elements = metadata.descendantElements;
  return Map.fromIterables(elements, expectedValues);
}

void main() {
  group('Item.fileName is correctly extracted in different scenarios', () {
    final parameterizedCases = {
      Item(
        id: 's001',
        href: 'Text/p001.xhtml.smil',
        mediaType: ItemMediaType.mediaOverlay,
        source: MockEpub(),
      ): 'p001.xhtml.smil',
      Item(
        id: 'm001',
        href: 'Audio/p001.mp3',
        mediaType: ItemMediaType.audioMP3,
        source: MockEpub(),
      ): 'p001.mp3',
      Item(
        id: 'c001',
        href: 'Styles/style.css',
        mediaType: ItemMediaType.css,
        source: MockEpub(),
      ): 'style.css',
    };

    parameterizedCases.forEach((item, expectedFileName) {
      test('FileName returns the expected output', () {
        expect(item.fileName, equals(expectedFileName));
      });
    });
  });

  test('Item.fileContent is correctly extracted', () {
    final epub = Epub.fromFile(File('test/resources/demo.epub'));
    final expectedFile = File('test/resources/p001.xhtml.smil');
    final item = Item(
      id: 's001',
      href: 'Text/p001.xhtml.smil',
      mediaType: ItemMediaType.mediaOverlay,
      source: epub,
    );

    expect(item.fileContent, equals(expectedFile.readAsBytesSync()));
  });

  test('Item.fileContent throws error when file is not found', () {
    final epub = Epub.fromFile(File('test/resources/demo.epub'));
    final item = Item(
      id: 's001',
      href: 'Text/s001.xhtml.smil',
      mediaType: ItemMediaType.mediaOverlay,
      source: epub,
    );

    expect(() => item.fileContent, throwsAssertionError);
  });

  group('XmlParsing.toItem parses Item correctly', () {
    final expectedValues = [
      Item(
        id: 'toc',
        href: 'Text/toc.xhtml',
        mediaType: ItemMediaType.xhtml,
        source: MockEpub(),
        properties: const [ItemProperty.nav],
      ),
      Item(
        id: 'cover.png',
        href: 'Images/cover.png',
        mediaType: ItemMediaType.png,
        source: MockEpub(),
        properties: const [ItemProperty.coverImage],
      ),
      Item(
        id: 'c001',
        href: 'Styles/style.css',
        mediaType: ItemMediaType.css,
        source: MockEpub(),
      ),
      Item(
        id: 'p001',
        href: 'Text/p001.xhtml',
        mediaType: ItemMediaType.xhtml,
        source: MockEpub(),
      ),
      Item(
        id: 's001',
        href: 'Text/p001.xhtml.smil',
        mediaType: ItemMediaType.mediaOverlay,
        source: MockEpub(),
      ),
      Item(
        id: 'm001',
        href: 'Audio/p001.mp3',
        mediaType: ItemMediaType.audioMP3,
        source: MockEpub(),
      ),
    ];

    final parameterizedCases = _getParameterizedCases(
      'test/resources/manifest_item_cases.xml',
      '/manifest',
      expectedValues,
    );

    parameterizedCases.forEach((element, expectedValue) {
      test('Item is parsed correctly', () {
        final parsedItem = Item.fromXmlElement(element, source: MockEpub());
        expect(parsedItem, expectedValue);
      });
    });
  });
}
