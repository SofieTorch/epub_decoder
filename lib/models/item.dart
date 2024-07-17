import 'package:epub_parser/models/item_media_type.dart';
import 'package:epub_parser/models/item_property.dart';

class Item {
  Item({
    required this.id,
    required this.href,
    required this.mediaType,
    this.mediaOverlay,
    this.properties = const [],
  });

  final String id;
  final String href;
  final ItemMediaType mediaType;
  final List<ItemProperty> properties;
  Item? mediaOverlay;

  @override
  String toString() {
    return {
      'id': id,
      'href': href,
      'mediaType': mediaType,
      'properties': properties.toString(),
      'mediaOverlay': mediaOverlay.toString(),
    }.toString();
  }
}
