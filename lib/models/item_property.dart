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
