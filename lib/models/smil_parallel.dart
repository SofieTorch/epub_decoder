import 'package:epub_parser/extensions/duration_parsing.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

class SmilParallel {
  const SmilParallel({
    required this.id,
    required this.clipBegin,
    required this.clipEnd,
    required this.textFileName,
    required this.textId,
  });

  final String id;
  final Duration clipBegin;
  final Duration clipEnd;
  final String textFileName;
  final String textId;

  factory SmilParallel.fromParXml(XmlElement xml) {
    final audioNode = xml.xpath('audio').first;
    final textNode = xml.xpath('text').first;
    return SmilParallel(
      id: xml.getAttribute('id')!,
      clipBegin: const Duration().fromString(
        audioNode.getAttribute('clipBegin')!,
      ),
      clipEnd: const Duration().fromString(
        audioNode.getAttribute('clipEnd')!,
      ),
      textFileName: textNode.getAttribute('src')!.split('#').first,
      textId: textNode.getAttribute('src')!.split('#').last,
    );
  }

  @override
  String toString() {
    return {
      'id': id,
      'clipBegin': clipBegin,
      'clipEnd': clipEnd,
      'textFileName': textFileName,
      'textId': textId,
    }.toString();
  }
}
