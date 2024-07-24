import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:epub_decoder/epub.dart';
import 'package:epub_decoder/models/document_metadata.dart';
import 'package:epub_decoder/models/item_media_type.dart';
import 'package:epub_decoder/models/item_property.dart';

/// Representation of a resource (file) inside the EPUB.
///
/// Specifically, the `<item>` tag in EPUB Manifest.
class Item {
  Item({
    required this.id,
    required this.href,
    required this.mediaType,
    required Epub source,
    this.mediaOverlay,
    this.properties = const [],
    this.refinements = const [],
  }) : _source = source.zip;

  /// Unique identifier in the whole EPUB.
  final String id;

  /// Relative path of the represented file.
  final String href;

  /// Media type of the represented file.
  final ItemMediaType mediaType;

  /// Special uses for this item.
  final List<ItemProperty> properties;

  /// Additional information for this item.
  List<DocumentMetadata> refinements;

  /// Representation of audio synchronized with the EPUB Content.
  Item? mediaOverlay;

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
  String toString() {
    return {
      'id': id,
      'href': href,
      'mediaType': mediaType,
      'properties': properties.toString(),
      'mediaOverlay': mediaOverlay.toString(),
      'refinements': refinements.toString(),
    }.toString();
  }
}
