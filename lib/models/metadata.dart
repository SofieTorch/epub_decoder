import 'package:epub_parser/models/document_metadata.dart';

abstract class Metadata {
  Metadata({this.id, this.value, this.refinements = const []});

  String? id;
  final String? value;
  List<DocumentMetadata> refinements;

  bool get isEmpty {
    return id == null && value == null && refinements.isEmpty;
  }
}
