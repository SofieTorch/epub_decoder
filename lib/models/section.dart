import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:epub_parser/epub.dart';
import 'package:epub_parser/models/models.dart';
import 'package:epub_parser/string_to_duration_parsing.dart';
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
  List<SmilParallel>? _smilParallels;

  Duration? get duration {
    final durationstr = content.mediaOverlay?.refinements
        .firstWhere((refinement) => refinement.property == 'media:duration')
        .value;

    return durationstr != null
        ? const Duration().fromString(durationstr)
        : null;
  }

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
    if (_smilParallels != null) return _smilParallels!;
    if (audio == null) return [];

    final xmlParallels = _smil.findAllElements('par');
    final result = xmlParallels.map(SmilParallel.fromParXml);
    _smilParallels = result.toList();

    return _smilParallels!;
  }

  SmilParallel? getParallelAtTime(Duration currentTime) {
    if (duration == null) return null;
    assert(currentTime <= duration!);

    final parallel = smilParallels.firstWhere(
      (par) => currentTime >= par.clipBegin && currentTime <= par.clipEnd,
    );

    return parallel;
  }

  @override
  String toString() {
    return {
      'content': content,
      'readingOrder': readingOrder,
      'duration': duration,
      'smilParallels': smilParallels,
    }.toString();
  }
}
