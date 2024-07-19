import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:epub_parser/epub.dart';
import 'package:epub_parser/models/models.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

class Section {
  Section({
    required this.epub,
    required this.content,
    required this.readingOrder,
  })  : assert(content.mediaType == ItemMediaType.xhtml),
        assert(content.mediaOverlay != null
            ? content.mediaOverlay?.mediaType == ItemMediaType.mediaOverlay
            : true);

  final Epub epub;
  final Item content;
  final int readingOrder;
  ArchiveFile? _audio;

  XmlDocument get _smil => XmlDocument.parse(
        utf8.decode(content.mediaOverlay!.getFileContent(epub)),
      );

  Uint8List? get audio {
    if (_audio != null) return _audio!.content;
    if (content.mediaOverlay == null) return null;

    final audioNode = _smil.xpath('/smil/body/seq/par/audio').first;
    final audioPath = audioNode.getAttribute('src')!;
    final audioFile = epub.zip.findFile('OEBPS/${audioPath.substring(3)}');

    if (audioFile == null) {
      throw UnimplementedError('Audio file: $audioPath not found');
    }

    _audio = audioFile;
    return _audio!.content;
  }

  List<SmilParallel> get smilParallels {
    if (audio == null) return [];

    final xmlParallels = _smil.findAllElements('par');
    final result = xmlParallels.map(SmilParallel.fromParXml);

    return result.toList();
  }

  @override
  String toString() {
    return {
      'content': content,
      'readingOrder': readingOrder,
      'smilParallels': smilParallels,
    }.toString();
  }
}
