import 'package:epub_parser/epub.dart';
import 'package:epub_parser/models/models.dart';
import 'package:xml/xml.dart';

extension XmlParsing on XmlElement {
  Item toManifestItem({required Epub source}) {
    return Item(
      id: getAttribute('id')!,
      source: source,
      href: getAttribute('href')!,
      mediaType: ItemMediaType.fromValue(getAttribute('media-type')!),
      properties: getAttribute('properties')
              ?.split(' ')
              .map((property) => ItemProperty.fromValue(property))
              .toList() ??
          [],
    );
  }

  DocumentMetadata toDocumentMetadata() {
    return DocumentMetadata(
      refinesTo: getAttribute('refines')?.substring(1),
      property: getAttribute('property'),
      value: innerText,
      id: getAttribute('id'),
      schema: getAttribute('schema'),
      name: getAttribute('name'),
      content: getAttribute('content'),
    );
  }

  DublinCoreMetadata toDublinCoreMetadata() {
    return DublinCoreMetadata(
      key: name.toString().substring(3),
      value: innerText,
      id: getAttribute('id'),
    );
  }
}
