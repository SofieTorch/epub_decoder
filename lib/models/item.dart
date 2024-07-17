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
  final String mediaType;
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

enum ItemProperty {
  coverImage('cover-image'),
  mathML('mathml'),
  scripted('scripted'),
  svg('svg'),
  remoteResources('remote-resources'),
  $switch('switch'),
  nav('nav');

  const ItemProperty(this.value);
  final String value;

  static ItemProperty fromValue(String value) {
    return ItemProperty.values.firstWhere((item) => item.value == value);
  }
}
