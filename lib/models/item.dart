import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:epub_parser/epub.dart';
import 'package:epub_parser/models/document_metadata.dart';
import 'package:epub_parser/models/item_media_type.dart';
import 'package:epub_parser/models/item_property.dart';

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

  final String id;
  final String href;
  final ItemMediaType mediaType;
  final List<ItemProperty> properties;
  final Archive _source;
  List<DocumentMetadata> refinements;
  Item? mediaOverlay;

  String get fileName => href.split('/').last;

  Uint8List get fileContent {
    final file = _source.findFile('OEBPS/$href');
    return file?.content;
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
