import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';
import 'package:archive/archive.dart';
import 'package:epub_parser/models/models.dart';
import 'package:epub_parser/standar_constants.dart';

class Epub {
  Epub.fromBytes(this.fileBytes) : zip = ZipDecoder().decodeBytes(fileBytes);

  Epub.fromFile(File file)
      : assert(file.path.extension == 'epub'),
        fileBytes = file.readAsBytesSync(),
        zip = ZipDecoder().decodeBytes(file.readAsBytesSync());

  final Uint8List fileBytes;
  final Archive zip;

  String get _rootFilePath {
    final container = zip.findFile(CONTAINER_FILE_PATH);
    container ?? (throw const FormatException('Container file not found.'));

    final content = XmlDocument.parse(utf8.decode(container.content));
    final path = content.rootElement
        .xpath('/container/rootfiles/rootfile')
        .first
        .getAttribute('full-path');

    path ?? (throw const FormatException('full-path attribute not found.'));
    return path;
  }

  XmlDocument get _rootFileContent {
    final file = zip.findFile(_rootFilePath);
    file ?? (throw const FormatException('Root file not found.'));
    final content = XmlDocument.parse(utf8.decode(file.content));
    return content;
  }

  List<Metadata> getMetadata() {
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
          /// .add() throws error for unknown reason.
          target.refinements = [...target.refinements, docmetadata];
        }
      }
    });

    return metadata;
  }

  List<Item> getItems() {
    final items = <Item>[];
    final itemsxml = _rootFileContent.xpath('/package/manifest').first;

    for (var element in itemsxml.descendantElements) {
      final item = element.toManifestItem();
      final mediaOverlayId = element.getAttribute('media-overlay');

      if (mediaOverlayId != null) {
        final mediaOverlay = itemsxml.descendantElements.firstWhere(
          (itemxml) => itemxml.getAttribute('id') == mediaOverlayId,
          orElse: () => throw UnimplementedError(
              'Referenced media overlay not found or not declared.'),
        );
        item.mediaOverlay = mediaOverlay.toManifestItem();
      }
      items.add(item);
    }
    return items;
  }
}

extension on String {
  String get extension => split('.').last;
}

extension on XmlElement {
  Item toManifestItem() {
    return Item(
      id: getAttribute('id')!,
      href: getAttribute('href')!,
      mediaType: getAttribute('media-type')!,
      properties: getAttribute('properties')
              ?.split(' ')
              .map((property) => ItemProperty.fromValue(property))
              .toList() ??
          [],
    );
  }

  DocumentMetadata toDocumentMetadata() {
    return DocumentMetadata(
      refinesTo: getAttribute('refines')?.substring(1),
      property: getAttribute('property'),
      value: innerText,
      id: getAttribute('id'),
      schema: getAttribute('schema'),
      name: getAttribute('name'),
      content: getAttribute('content'),
    );
  }

  DublinCoreMetadata toDublinCoreMetadata() {
    return DublinCoreMetadata(
      key: name.toString().substring(3),
      value: innerText,
      id: getAttribute('id'),
    );
  }
}
