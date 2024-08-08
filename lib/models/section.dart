import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:epub_decoder/epub.dart';
import 'package:epub_decoder/models/models.dart';
import 'package:epub_decoder/extensions/duration_parsing.dart';
import 'package:equatable/equatable.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

/// References an [Item] to be read as main content from the EPUB.
class Section extends Equatable {
  /// Creates a group of text and audio that are part of an EPUB main content.
  Section({
    required Epub source,
    required this.content,
    required this.readingOrder,
  })  : _source = source.zip,
        assert(content.mediaType == ItemMediaType.xhtml),
        assert(content.mediaOverlay != null
            ? content.mediaOverlay?.mediaType == ItemMediaType.mediaOverlay
            : true) {
    _audio = Lazy(_initializeAudio);
    _smilParallels = Lazy(_initializeSmilParallels);
  }

  /// Representation of XHTML text content.
  ///
  /// Can include an audio version in [Item.mediaOverlay].
  final Item content;

  /// Position relative to the other sections in the [_source].
  final int readingOrder;

  /// Source EPUB where this is from.
  final Archive _source;
  late final Lazy<ArchiveFile?> _audio;
  late final Lazy<List<SmilParallel>> _smilParallels;

  /// Media Overlay file represented in XML.
  ///
  /// Returns `null` if the section has no audio version.
  XmlDocument? get _smil {
    if (!hasAudio) return null;

    return XmlDocument.parse(
      utf8.decode(content.mediaOverlay!.fileContent),
    );
  }

  /// Wheter this section has audio version.
  bool get hasAudio => content.mediaOverlay != null;

  /// Audio version of the section, represented in bytes as [Uint8List].
  ///
  /// Returns `null` if the section has no audio version.
  Uint8List? get audio => _audio.value?.content;

  /// Parallels declared in the Media Overlay file.
  ///
  /// Returns an empty list if the section has no audio version.
  List<SmilParallel> get smilParallels => _smilParallels.value;

  /// Duration of [Section.audio], as specified in [_source.metadata].
  ///
  /// Returns `null` if the section has no audio version.
  Duration? get audioDuration {
    if (!hasAudio) return null;

    final durationMetadata = content.mediaOverlay!.refinements.firstWhere(
      (refinement) => refinement.property == 'media:duration',
      orElse: () => DocumentMetadata(),
    );

    if (durationMetadata.value == null) {
      throw StateError(
        '''Duration not specified in metadata
        for media overlay #${content.mediaOverlay?.id}''',
      );
    }

    return const Duration().fromString(durationMetadata.value!);
  }

  /// Returns the [SmilParallel] corresponding to [currentTime].
  ///
  /// Returns `null` if the section has no audio version.
  SmilParallel? getParallelAtTime(Duration currentTime) {
    if (!hasAudio) return null;
    assert(currentTime <= audioDuration!);

    final parallel = smilParallels.firstWhere(
      (par) => currentTime >= par.clipBegin && currentTime <= par.clipEnd,
    );

    return parallel;
  }

  @override
  List<Object?> get props => [content, readingOrder, _audio, _smilParallels];

  ArchiveFile? _initializeAudio() {
    if (!hasAudio) return null;

    final audioNode = _smil!.xpath('/smil/body/seq/par/audio').first;
    final audioPath = audioNode.getAttribute('src')!;
    final audioFile = _source.findFile('OEBPS/${audioPath.substring(3)}');

    if (audioFile == null) {
      throw FileSystemException('Audio file: $audioPath not found');
    }

    return audioFile;
  }

  List<SmilParallel> _initializeSmilParallels() {
    if (!hasAudio) return [];

    final xmlParallels = _smil!.findAllElements('par');
    final result = xmlParallels.map(SmilParallel.fromXmlElement);

    return result.toList();
  }
}
