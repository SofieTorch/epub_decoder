import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:epub_decoder/epub.dart';
import 'package:epub_decoder/models/models.dart';
import 'package:epub_decoder/extensions/duration_parsing.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

/// References an [Item] to be read as main content from the EPUB.
class Section {
  /// Creates a group of text and audio that are part of an EPUB main content.
  Section({
    required this.epub,
    required this.content,
    required this.readingOrder,
  })  : assert(content.mediaType == ItemMediaType.xhtml),
        assert(content.mediaOverlay != null
            ? content.mediaOverlay?.mediaType == ItemMediaType.mediaOverlay
            : true) {
    _audio = Lazy(_initializeAudio);
    _smilParallels = Lazy(_initializeSmilParallels);
  }

  /// Source EPUB where this is from.
  final Epub epub;

  /// Representation of XHTML text content.
  ///
  /// Can include an audio version in [Item.mediaOverlay].
  final Item content;

  /// Position relative to the other sections in the [epub].
  final int readingOrder;

  late final Lazy<ArchiveFile?> _audio;
  late final Lazy<List<SmilParallel>> _smilParallels;

  /// Wheter this section has audio version.
  bool get hasAudio => content.mediaOverlay != null;

  /// Duration of [Section.audio], as specified in [epub.metadata].
  ///
  /// Returns `null` if the section has no audio version.
  Duration? get audioDuration {
    if (!hasAudio) return null;

    final durationstr = content.mediaOverlay!.refinements
        .firstWhere((refinement) => refinement.property == 'media:duration')
        .value;

    if (durationstr == null) {
      throw AssertionError(
        'Duration not specified in metadata for media overlay #${content.mediaOverlay?.id}',
      );
    }
    return const Duration().fromString(durationstr);
  }

  /// Audio version of the section, represented in bytes as [Uint8List].
  ///
  /// Returns `null` if the section has no audio version.
  Uint8List? get audio {
    return _audio.value?.content;
  }

  ArchiveFile? _initializeAudio() {
    if (!hasAudio) return null;

    final audioNode = _smil!.xpath('/smil/body/seq/par/audio').first;
    final audioPath = audioNode.getAttribute('src')!;
    final audioFile = epub.zip.findFile('OEBPS/${audioPath.substring(3)}');

    if (audioFile == null) {
      throw UnimplementedError('Audio file: $audioPath not found');
    }

    return audioFile;
  }

  /// Parallels declared in the Media Overlay file.
  ///
  /// Returns an empty list if the section has no audio version.
  List<SmilParallel> get smilParallels {
    return _smilParallels.value;
  }

  List<SmilParallel> _initializeSmilParallels() {
    if (!hasAudio) return [];

    final xmlParallels = _smil!.findAllElements('par');
    final result = xmlParallels.map(SmilParallel.fromParXml);

    return result.toList();
  }

  /// Returns the [SmilParallel] corresponding to [currentTime].
  ///
  /// Returns `null` if the section has no audio version.
  SmilParallel? getParallelAtTime(Duration currentTime) {
    if (audioDuration == null) return null;
    assert(currentTime <= audioDuration!);

    final parallel = smilParallels.firstWhere(
      (par) => currentTime >= par.clipBegin && currentTime <= par.clipEnd,
    );

    return parallel;
  }

  /// Media Overlay file represented in XML.
  ///
  /// Returns `null` if the section has no audio version.
  XmlDocument? get _smil {
    if (!hasAudio) return null;

    return XmlDocument.parse(
      utf8.decode(content.mediaOverlay!.fileContent),
    );
  }

  @override
  String toString() {
    return {
      'content': content,
      'readingOrder': readingOrder,
      'audioDuration': audioDuration,
      'smilParallels': smilParallels,
    }.toString();
  }
}
