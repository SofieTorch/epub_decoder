import 'package:epub_decoder/models/metadata.dart';
import 'package:epub_decoder/models/models.dart';
import 'package:xml/xml.dart';

/// Specific and primary information associated to an EPUB.
///
/// This type of metadata represents info such as
/// title, authors, contributors, language, etc.
class DublinCoreMetadata extends Metadata {
  /// Creates metadata describing relevant information about an EPUB.
  DublinCoreMetadata({
    required this.key,
    required super.value,
    super.id,
  });

  /// Creates a [DublinCoreMetadata] from an XML `<dc:` tag inside EPUB `<metadata>`.
  factory DublinCoreMetadata.fromXmlElement(XmlElement xml) {
    return DublinCoreMetadata(
      key: xml.name.toString().substring(3),
      value: xml.innerText,
      id: xml.getAttribute('id'),
    );
  }

  /// The piece of metadata being represented.
  ///
  /// Identifies the type of metadata, such as 'title',
  /// 'author', 'contributor', 'language', 'identifier', etc.
  final String key;

  @override
  bool get isEmpty {
    return key.isEmpty && super.isEmpty;
  }

  @override
  List<Object?> get props => [key, id, value, refinements];
}
