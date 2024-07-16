import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:epub_parser/dublin_core_metadata.dart';

import 'package:epub_parser/standar_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

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

  void getMetadata() {
    final metadata = <String, List<DublinCoreMetadata>>{};
    final metadataxml = _rootFileContent.xpath('/package/metadata').first;

    metadataxml.descendantElements
        .where((element) => element.name.toString().startsWith('dc:'))
        .forEach((element) {
      final key = element.name.toString().substring(3);
      final dcmetadata = DublinCoreMetadata(
        key: key,
        value: element.innerText,
        id: element.getAttribute('id'),
      );

      metadata[key] = [...?metadata[key], dcmetadata];
    });

    metadataxml.descendantElements
        .where((element) =>
            element.name.toString() == 'meta' &&
            element.getAttribute('refines') != null)
        .forEach((element) {
      final targetValue = metadata.values.firstWhere(
        (value) => value.any(
          (meta) => '#${meta.id}' == element.getAttribute('refines'),
        ),
        orElse: () => [],
      );
      if (targetValue.isEmpty) return;

      final targetMetadata = targetValue.firstWhere(
          (meta) => '#${meta.id}' == element.getAttribute('refines'));

      /// refines.addAll() and refines[key]=value throws error for unknown reason.
      targetMetadata.refines = {
        ...targetMetadata.refines,
        element.getAttribute('property').toString(): element.innerText,
      };
    });

    print(metadata);
  }
}

extension on String {
  String get extension => split('.').last;
}
