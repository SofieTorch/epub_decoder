import 'package:epub_decoder/models/document_metadata.dart';

///  Relevant information associated to an EPUB or its elements.
abstract class Metadata {
  Metadata({this.id, this.value});

  /// Unique identifier in the whole EPUB.
  final String? id;

  /// Information associated to this metadata.
  final String? value;

  /// Additional information for this metadata.
  final List<DocumentMetadata> refinements = [];

  /// Empty instance of [Metadata].
  static Metadata get empty => DocumentMetadata();

  /// Whether every attribute is empty or null.
  bool get isEmpty {
    return id == null && value == null && refinements.isEmpty;
  }
}
