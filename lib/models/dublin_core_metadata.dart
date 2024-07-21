import 'package:epub_parser/models/metadata.dart';

/// Specific and primary information associated to an EPUB.
///
/// This type of metadata represents info such as
/// title, authors, contributors, language, etc.
class DublinCoreMetadata extends Metadata {
  DublinCoreMetadata({
    required this.key,
    required super.value,
    super.id,
    super.refinements = const [],
  });

  /// The piece of metadata being represented.
  ///
  /// Identifies the type of metadata, such as 'title',
  /// 'author', 'contributor', 'language', 'identifier', etc.
  final String key;

  @override
  bool get isEmpty {
    return key.trim() == '' && super.isEmpty;
  }

  @override
  String toString() {
    return {
      'key': key,
      'id': id,
      'value': value,
      'refinements': refinements.toString(),
    }.toString();
  }
}
