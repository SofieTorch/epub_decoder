import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:epub_decoder/epub.dart';
import 'package:epub_decoder/models/document_metadata.dart';
import 'package:epub_decoder/models/item_media_type.dart';
import 'package:epub_decoder/models/item_property.dart';
import 'package:equatable/equatable.dart';
import 'package:xml/xml.dart';

/// Representation of a resource (file) inside the EPUB.
///
/// Specifically, the `<item>` tag in EPUB Manifest.
class Item extends Equatable {
  Item({
    required this.id,
    required this.href,
    required this.mediaType,
    required Epub source,
    this.mediaOverlay,
    this.properties = const [],
  }) : _source = source.zip;

  /// Creates an [Item] from an XML `<item>` tag inside EPUB `<manifest>`.
  factory Item.fromXmlElement(
    XmlElement xml, {
    required Epub source,
    Item? mediaOverlay,
  }) {
    return Item(
      id: xml.getAttribute('id')!,
      source: source,
      href: xml.getAttribute('href')!,
      mediaType: ItemMediaType.fromValue(xml.getAttribute('media-type')!),
      mediaOverlay: mediaOverlay,
      properties: xml
              .getAttribute('properties')
              ?.split(' ')
              .map((property) => ItemProperty.fromValue(property))
              .toList() ??
          [],
    );
  }

  /// Unique identifier in the whole EPUB.
  final String id;

  /// Relative path of the represented file.
  final String href;

  /// Media type of the represented file.
  final ItemMediaType mediaType;

  /// Indicators that this item has some special use case, such as cover image, svg, etc.
  ///
  /// See [ItemProperty] for all the available use cases.
  final List<ItemProperty> properties;

  /// Additional information for this item.
  final List<DocumentMetadata> refinements = [];

  /// Representation of audio synchronized with the EPUB Content.
  final Item? mediaOverlay;

  final Archive _source;

  /// Name of the represented file.
  String get fileName => href.split('/').last;

  /// File content from [href] in bytes, represented as [Uint8List].
  ///
  /// Throws an [AssertionError] if the file could not be found.
  Uint8List get fileContent {
    final file = _source.findFile('OEBPS/$href');
    if (file == null) {
      throw AssertionError('File in href OEBPS/$href does not exists');
    }

    return file.content;
  }

  @override
  List<Object?> get props => [
        id,
        href,
        mediaType,
        properties,
        mediaOverlay,
        refinements,
      ];
}
