import 'package:epub_decoder/models/dublin_core_metadata.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  test('isEmpty is true when every attribute is empty', () {
    final metadata = DublinCoreMetadata(key: '', value: '');

    expect(metadata.isEmpty, true);
  });

  test('isEmpty is false when any attribute is not empty', () {
    final metadata = DublinCoreMetadata(key: 'title', value: 'The Hobbit');

    expect(metadata.isEmpty, false);
  });

  group('DublinCoreMetadata.fromXmlElement in different scenarios', () {
    final expectedValues = [
      DublinCoreMetadata(id: 'title', key: 'title', value: 'Sonnets'),
      DublinCoreMetadata(id: 'aut', key: 'creator', value: 'Alberto Pettarin'),
      DublinCoreMetadata(key: 'language', value: 'it'),
      DublinCoreMetadata(key: 'subject', value: 'William Shakespeare'),
      DublinCoreMetadata(key: 'type', value: 'Book')
    ];

    final parameterizedCases = getParameterizedCases(
      'test/resources/dublin_core_metadata_cases.xml',
      '/metadata',
      expectedValues,
    );

    parameterizedCases.forEach((element, expectedValue) {
      test('DublinCoreMetadata is created correctly from XmlElement', () {
        final parsedMetadata = DublinCoreMetadata.fromXmlElement(element);
        expect(parsedMetadata, expectedValue);
      });
    });
  });
}
