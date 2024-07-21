import 'package:epub_parser/models/document_metadata.dart';

///  Relevant information associated to an EPUB or its elements.
abstract class Metadata {
  Metadata({this.id, this.value, this.refinements = const []});

  /// Unique identifier in the whole EPUB.
  String? id;

  /// Information associated to this metadata.
  final String? value;

  /// Additional information for this metadata.
  List<DocumentMetadata> refinements;

  /// Empty instance of [Metadata].
  static Metadata get empty => DocumentMetadata();

  /// Whether every attribute is empty or null.
  bool get isEmpty {
    return id == null && value == null && refinements.isEmpty;
  }
}
