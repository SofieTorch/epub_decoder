import 'dart:typed_data';

import 'package:epub_parser/epub.dart';
import 'package:epub_parser/models/document_metadata.dart';
import 'package:epub_parser/models/item_media_type.dart';
import 'package:epub_parser/models/item_property.dart';

class Item {
  Item({
    required this.id,
    required this.href,
    required this.mediaType,
    this.mediaOverlay,
    this.properties = const [],
    this.refinements = const [],
  });

  final String id;
  final String href;
  final ItemMediaType mediaType;
  final List<ItemProperty> properties;
  List<DocumentMetadata> refinements;
  Item? mediaOverlay;

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

  Uint8List getFileContent(Epub source) {
    final file = source.zip.findFile('OEBPS/$href');
    return file?.content;
  }
}
