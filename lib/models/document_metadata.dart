import 'package:epub_decoder/models/metadata.dart';
import 'package:xml/xml.dart';

/// Relevant and flexible information associated to
/// an [Item], another [Metadata], or the EPUB package itself.
class DocumentMetadata extends Metadata {
  /// Creates metadata that could be either for
  /// another element or the EPUB package itself.
  DocumentMetadata({
    this.refinesTo,
    String? property,
    super.value,
    super.id,
    this.scheme,
    this.name,
    this.content,
  }) : _property = property;

  /// Creates a [DocumentMetadata] from an XML `<meta>` tag inside EPUB `<metadata>`.
  factory DocumentMetadata.fromXmlElement(XmlElement xml) {
    return DocumentMetadata(
      refinesTo: xml.getAttribute('refines')?.substring(1),
      property: xml.getAttribute('property'),
      value: xml.innerText.isNotEmpty ? xml.innerText : null,
      id: xml.getAttribute('id'),
      scheme: xml.getAttribute('scheme'),
      name: xml.getAttribute('name'),
      content: xml.getAttribute('content'),
    );
  }

  /// Identifier of the described item or metadata.
  final String? refinesTo;

  /// Property being described for [refinesTo] in EPUB3.
  final String? _property;

  /// Formal definition of [property].
  final String? scheme;

  /// Property being described to [refinesTo] in EPUB2.
  final String? name;

  /// Content of the metadata element in EPUB2.
  final String? content;

  /// Property being described to [refinesTo].
  ///
  /// Returns its equivalent [name] for EPUB2 metadata elements.
  String? get property {
    if (_property != null) return _property;
    if (name != null) return name;
    return null;
  }

  /// Content of the metadata element.
  ///
  /// Returns its equivalent [content] for EPUB2 metadata elements.
  @override
  String? get value {
    if (super.value != null) return super.value;
    if (content != null) return content;
    return null;
  }

  @override
  bool get isEmpty {
    return refinesTo == null &&
        property == null &&
        scheme == null &&
        name == null &&
        content == null &&
        super.isEmpty;
  }

  @override
  List<Object?> get props => [
        id,
        value,
        refinesTo,
        property,
        scheme,
        name,
        content,
        refinements,
      ];
}
