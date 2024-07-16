import 'package:epub_parser/models/metadata.dart';

class DocumentMetadata extends Metadata {
  DocumentMetadata({
    this.refinesTo,
    this.property,
    super.value,
    super.id,
    this.schema,
    this.name,
    this.content,
    super.refinements = const [],
  });

  final String? refinesTo;
  final String? property;
  final String? schema;
  final String? name;
  final String? content;

  @override
  bool get isEmpty {
    return refinesTo == null &&
        property == null &&
        schema == null &&
        name == null &&
        content == null &&
        super.isEmpty;
  }

  @override
  String toString() {
    return {
      'id': id,
      'value': value,
      'refinesTo': refinesTo,
      'property': property,
      'schema': schema,
      'name': name,
      'content': content,
      'refinements': refinements.toString(),
    }.toString();
  }
}
