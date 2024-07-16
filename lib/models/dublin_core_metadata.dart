import 'package:epub_parser/models/metadata.dart';

class DublinCoreMetadata extends Metadata {
  DublinCoreMetadata({
    required this.key,
    required super.value,
    super.id,
    super.refinements = const [],
  });

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
