import 'dart:io';

import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

Map<XmlElement, dynamic> getParameterizedCases(
  String xmlFilePath,
  String xmlXpath,
  List<dynamic> expectedValues,
) {
  final xmlFile = File(xmlFilePath);
  final xmlDocument = XmlDocument.parse(xmlFile.readAsStringSync());
  final node = xmlDocument.xpath(xmlXpath).first;
  final elements = node.childElements;
  return Map.fromIterables(elements, expectedValues);
}
