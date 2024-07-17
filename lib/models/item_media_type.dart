enum ItemMediaType {
  gif('image/gif'),
  jpeg('image/jpeg'),
  png('image/png'),
  svg('image/svg+xml'),
  xhtml('application/xhtml+xml'),
  script('application/javascript'),
  ncx('application/x-dtbncx+xml'),
  fontOtfTtf('application/font-sfnt'),
  fontWoff('application/font-woff'),
  fontWoff2('font/woff2'),
  mediaOverlay('application/smil+xml'),
  textToSpechPLS('application/pls+xml'),
  audioMP3('audio/mpeg'),
  audioMP4('audio/mp4'),
  css('text/css');

  const ItemMediaType(this.value);
  final String value;

  static ItemMediaType fromValue(String value) {
    return ItemMediaType.values
        .firstWhere((mediaType) => mediaType.value == value);
  }
}
