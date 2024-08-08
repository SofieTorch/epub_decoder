import 'package:epub_decoder/extensions/duration_parsing.dart';
import 'package:equatable/equatable.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

/// Segment of audio-text synchronization through Media Overlays.
///
/// SMIL from the specification Synchronized Multimedia Integration Language.
/// Parallel is a representation of <par> elements which contains media objects.
/// This should be part of a sequence of parallels, usually inside a [Section],
/// which is where the audio and text/content comes from.
class SmilParallel extends Equatable {
  /// Creates a [SmilParallel], representation
  /// of audio-text synchronization.
  const SmilParallel({
    required this.id,
    required this.clipBegin,
    required this.clipEnd,
    required this.textFileName,
    required this.textId,
  });

  /// Segment unique identifier in the EPUB.
  final String id;

  /// Segment beginning in [Section.audio].
  final Duration clipBegin;

  /// Segment ending in [Section.audio].
  final Duration clipEnd;

  /// Name of the associated text file.
  final String textFileName;

  /// Identifier of the text segment (inside the text file
  /// from [textFileName]) to be synchronized.
  final String textId;

  /// Creates a [SmilParallel] from a <par> xml element.
  factory SmilParallel.fromXmlElement(XmlElement xml) {
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
  List<Object?> get props => [id, clipBegin, clipEnd, textFileName, textId];
}
