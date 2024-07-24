import 'package:epub_decoder/epub.dart';
import 'package:epub_decoder/models/models.dart';
import 'package:xml/xml.dart';

/// Add extra parsing for [XmlElement] to EPUB objects.
extension XmlParsing on XmlElement {
  /// Creates an [Item] from an XML `<item>` tag inside EPUB `<manifest>`.
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

  /// Creates a [DocumentMetadata] from an XML `<meta>` tag inside EPUB `<metadata>`.
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

  /// Creates a [DublinCoreMetadata] from an XML `<dc:` tag inside EPUB `<metadata>`.
  DublinCoreMetadata toDublinCoreMetadata() {
    return DublinCoreMetadata(
      key: name.toString().substring(3),
      value: innerText,
      id: getAttribute('id'),
    );
  }
}
