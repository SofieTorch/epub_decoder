import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:epub_decoder/extensions/xml_parsing.dart';
import 'package:flutter/foundation.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';
import 'package:archive/archive.dart';
import 'package:epub_decoder/models/models.dart';
import 'package:epub_decoder/standar_constants.dart';

/// Representation of an EPUB file.
///
/// This class provides methods to parse an EPUB file from bytes or from a file,
/// and access its metadata, manifest items, and spine through [Section]s.
class Epub {
  /// Constructs an [Epub] instance from a list of bytes.
  ///
  /// The [fileBytes] parameter should contain the raw bytes of the EPUB file.
  Epub.fromBytes(Uint8List fileBytes)
      : zip = ZipDecoder().decodeBytes(fileBytes) {
    _metadata = Lazy(_initializeMetadata);
    _items = Lazy(_initializeItems);
    _sections = Lazy(_initializeSections);
  }

  /// Constructs an [Epub] instance from a [File].
  ///
  /// The [file] parameter should point to a valid EPUB file.
  Epub.fromFile(File file)
      : assert(file.path._extension == 'epub'),
        zip = ZipDecoder().decodeBytes(file.readAsBytesSync());

  /// The decoded ZIP archive of the EPUB file.
  final Archive zip;

  late final Lazy<List<Metadata>> _metadata;
  late final Lazy<List<Item>> _items;
  late final Lazy<List<Section>> _sections;

  /// Path to the root file (usually 'content.opf') in the EPUB.
  ///
  /// Throws a [FormatException] if the container file or the root file path
  /// is not found.
  String get _rootFilePath {
    final container = zip.findFile(containerFilePath);
    container ?? (throw const FormatException('Container file not found.'));

    final content = XmlDocument.parse(utf8.decode(container.content));
    final path = content.rootElement
        .xpath('/container/rootfiles/rootfile')
        .first
        .getAttribute('full-path');

    path ?? (throw const FormatException('full-path attribute not found.'));
    return path;
  }

  /// Content of the root file as an XML document.
  ///
  /// Throws a [FormatException] if the root file is not found.
  XmlDocument get _rootFileContent {
    final file = zip.findFile(_rootFilePath);
    file ?? (throw const FormatException('Root file not found.'));
    final content = XmlDocument.parse(utf8.decode(file.content));
    return content;
  }

  /// Metadata of the EPUB file, such as title, authors, media overlays, etc.
  ///
  /// This includes both Dublin Core metadata and additional document metadata.
  /// If the metadata has already been parsed, returns the cached metadata.
  List<Metadata> get metadata => _metadata.value;

  List<Metadata> _initializeMetadata() {
    final metadata = <Metadata>[];
    final metadataxml = _rootFileContent.xpath('/package/metadata').first;

    metadataxml.descendantElements
        .where((element) => element.name.toString().startsWith('dc:'))
        .forEach((element) {
      final dcmetadata = element.toDublinCoreMetadata();
      metadata.add(dcmetadata);
    });

    metadataxml.descendantElements
        .where((element) => element.name.toString() == 'meta')
        .forEach((element) {
      final docmetadata = element.toDocumentMetadata();

      if (docmetadata.refinesTo == null) {
        metadata.add(docmetadata);
      } else {
        final target = metadata.firstWhere(
          (metaelement) => docmetadata.refinesTo == metaelement.id,
          orElse: () => Metadata.empty,
        );

        if (target.isEmpty) {
          metadata.add(docmetadata);
        } else {
          target.refinements.add(docmetadata);
        }
      }
    });

    return metadata;
  }

  /// Resources (images, audio, text, etc.) of the EPUB file, as [Item]s.
  ///
  /// If the items have already been parsed, returns the cached items.
  List<Item> get items => _items.value;

  List<Item> _initializeItems() {
    final items = <Item>[];
    final itemsxml = _rootFileContent.xpath('/package/manifest').first;

    for (var element in itemsxml.descendantElements) {
      final mediaOverlayId = element.getAttribute('media-overlay');
      Item item;

      if (mediaOverlayId != null) {
        final mediaOverlay = itemsxml.descendantElements.firstWhere(
          (itemxml) => itemxml.getAttribute('id') == mediaOverlayId,
          orElse: () => throw UnimplementedError(
              'Referenced media overlay not found or not declared.'),
        );
        item = element.toManifestItem(
            source: this,
            mediaOverlay: mediaOverlay.toManifestItem(source: this));
      } else {
        item = element.toManifestItem(source: this);
      }

      item._addRefinementsFrom(metadata);
      item.mediaOverlay?._addRefinementsFrom(metadata);
      items.add(item);
    }

    return items;
  }

  /// Reading sections of the EPUB file in order.
  ///
  /// Sections are determined by the spine element in the EPUB's package document.
  /// If the sections have already been parsed, returns the cached sections.
  List<Section> get sections => _sections.value;

  List<Section> _initializeSections() {
    final sections = <Section>[];
    final spinexml = _rootFileContent.xpath('/package/spine').first;
    final spineItems = spinexml.findAllElements('itemref');
    for (var (index, itemref) in spineItems.indexed) {
      final item = items.firstWhere(
        (item) => item.id == itemref.getAttribute('idref'),
      );

      final section = Section(
        content: item,
        epub: this,
        readingOrder: index + 1,
      );

      sections.add(section);
    }

    return sections;
  }
}

extension on String {
  String get _extension => split('.').last;
}

extension on Item {
  void _addRefinementsFrom(List<Metadata> metadata) {
    final docmetadata = metadata
        .where((element) =>
            element is DocumentMetadata &&
            element.refinesTo != null &&
            element.refinesTo == id)
        .map((element) => element as DocumentMetadata);
    refinements.addAll(docmetadata);
  }
}
