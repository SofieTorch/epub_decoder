import 'package:epub_decoder/models/document_metadata.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  test('''Maps EPUB2 name and content to
    EPUB3 value and property correctly''', () {
    final metadata = DocumentMetadata(
      name: 'cover',
      content: 'cover.png',
    );

    expect(metadata.property, equals('cover'));
    expect(metadata.value, equals('cover.png'));
  });

  test('''Prioritizes EPUB3 property and value attributes
        over EPUB2 name and content attributes''', () {
    final metadata = DocumentMetadata(
      property: 'media:duration',
      value: '0:01:46.270',
      name: 'cover',
      content: 'cover.png',
    );

    expect(metadata.property, equals('media:duration'));
    expect(metadata.value, equals('0:01:46.270'));
  });

  test('isEmpty is true when all attributes are null', () {
    final metadata = DocumentMetadata();

    expect(metadata.isEmpty, true);
  });

  test('isEmpty is false when any attribute is not null', () {
    final metadata = DocumentMetadata(id: 'p001');

    expect(metadata.isEmpty, false);
  });

  group('DocumentMetadata.fromXmlElement in different scenarios', () {
    final expectedValues = [
      DocumentMetadata(
        property: 'identifier-type',
        refinesTo: 'pubID',
        scheme: 'xsd:string',
        value: 'uuid',
      ),
      DocumentMetadata(
        refinesTo: 'aut',
        property: 'role',
        scheme: 'marc:relators',
        value: 'aut',
      ),
      DocumentMetadata(
        refinesTo: 'aut',
        property: 'file-as',
        value: 'Pettarin, Alberto',
      ),
      DocumentMetadata(
        name: 'cover',
        content: 'cover.png',
      ),
      DocumentMetadata(
        property: 'media:duration',
        refinesTo: 's001',
        value: '0:00:53.320',
      ),
      DocumentMetadata(
        property: 'media:duration',
        value: '0:01:46.270',
      )
    ];

    final parameterizedCases = getParameterizedCases(
      'test/resources/document_metadata_cases.xml',
      '/metadata',
      expectedValues,
    );

    parameterizedCases.forEach((element, expectedValue) {
      test('DocumentMetadata is parsed correctly', () {
        final parsedMetadata = DocumentMetadata.fromXmlElement(element);
        expect(parsedMetadata, expectedValue);
      });
    });
  });
}
