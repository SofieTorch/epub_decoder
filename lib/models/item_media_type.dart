/// Allowed media types for resources in EPUB3.
///
/// Reference taken from https://www.w3.org/TR/epub/#sec-core-media-types
enum ItemMediaType {
  /// media-type for GIF images.
  gif('image/gif'),

  /// media-type for JPEG and JPG images.
  jpeg('image/jpeg'),

  /// media-type for PNG images.
  png('image/png'),

  /// media-type for SVG images.
  svg('image/svg+xml'),

  /// media-type for WebP images.
  webp('image/webp'),

  /// media-type for MP3 audio.
  audioMP3('audio/mpeg'),

  /// media-type for AAC LC audio using MP4 container.
  audioMP4('audio/mp4'),

  /// media-type for OPUS audio using OGG container.
  audioOpusOGG('audio/ogg; codecs=opus'),

  /// media-type for CSS Style Sheets.
  css('text/css'),

  /// media-type for TrueType fonts.
  fontTTf('font/ttf'),

  /// media-type for TrueType and OpenType fonts
  fontOtfTtf('application/font-sfnt'),

  /// media-type for OpenType fonts.
  fontOtf('font/otf'),

  /// media-type for OpenType fonts.
  fontOtfVnd('application/vnd.ms-opentype'),

  /// media-type for WOFF fonts.
  fontWoffApplication('application/font-woff'),

  /// media-type for WOFF fonts.
  fontWoff('application/font-woff'),

  /// media-type for WOFF2 fonts.
  fontWoff2('font/woff2'),

  /// media-type for HTML documents that use the XML syntax (EPUB text content).
  xhtml('application/xhtml+xml'),

  /// media-type for scripts.
  javascript('application/javascript'),

  /// media-type for scripts.
  script('text/javascript'),

  /// media-type for scripts.
  ecmascript('application/ecmascript'),

  /// media-type for the legacy NCX.
  ncx('application/x-dtbncx+xml'),

  /// media-type for EPUB media overlay documents.
  mediaOverlay('application/smil+xml'),

  /// media-type for the Text-to-Speech (TTS) Pronunciation lexicons.
  textToSpechPLS('application/pls+xml');

  const ItemMediaType(this.value);

  /// Representation in XML items.
  final String value;

  /// Create [ItemMediaType] enum from its representation in XML.
  static ItemMediaType fromValue(String value) {
    return ItemMediaType.values
        .firstWhere((mediaType) => mediaType.value == value);
  }
}
