class DublinCoreMetadata {
  DublinCoreMetadata({
    required this.key,
    required this.value,
    this.id,
    this.refines = const {},
  });

  final String key;
  final dynamic value;
  String? id;
  Map<String, dynamic> refines;

  @override
  String toString() {
    return {
      'key': key,
      'id': id,
      'value': value,
      'refines': refines.toString(),
    }.toString();
  }
}
