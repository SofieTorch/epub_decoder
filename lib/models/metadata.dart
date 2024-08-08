import 'package:epub_decoder/models/document_metadata.dart';
import 'package:equatable/equatable.dart';

///  Relevant information associated to an EPUB or its elements.
abstract class Metadata extends Equatable {
  Metadata({this.id, this.value});

  /// Unique identifier in the whole EPUB.
  final String? id;

  /// Information associated to this metadata.
  final String? value;

  /// Additional information for this metadata.
  final List<DocumentMetadata> refinements = [];

  /// Empty instance of [Metadata].
  static Metadata get empty => DocumentMetadata() as Metadata;

  /// Whether every attribute is empty or null.
  bool get isEmpty {
    final isIdEmpty = id == null || (id != null && id!.isEmpty);
    final isValueEmpty = value == null || (value != null && value!.isEmpty);
    return isIdEmpty && isValueEmpty && refinements.isEmpty;
  }
}
