import 'package:epub_decoder/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  group('SmilParallel.fromXmlElement in different scenarios', () {
    final expectedValues = [
      const SmilParallel(
        id: 'p000001',
        clipBegin: Duration(),
        clipEnd: Duration(seconds: 2, milliseconds: 680),
        textFileName: 'p001.xhtml',
        textId: 'f001',
      ),
      const SmilParallel(
        id: 'p000002',
        clipBegin: Duration(seconds: 2, milliseconds: 680),
        clipEnd: Duration(seconds: 5, milliseconds: 480),
        textFileName: 'p001.xhtml',
        textId: 'f002',
      ),
      const SmilParallel(
        id: 'p000003',
        clipBegin: Duration(seconds: 5, milliseconds: 480),
        clipEnd: Duration(seconds: 8, milliseconds: 640),
        textFileName: 'p001.xhtml',
        textId: 'f003',
      ),
      const SmilParallel(
        id: 'p000004',
        clipBegin: Duration(seconds: 8, milliseconds: 640),
        clipEnd: Duration(seconds: 11, milliseconds: 960),
        textFileName: 'p001.xhtml',
        textId: 'f004',
      ),
      const SmilParallel(
        id: 'p000005',
        clipBegin: Duration(seconds: 11, milliseconds: 960),
        clipEnd: Duration(seconds: 15, milliseconds: 279),
        textFileName: 'p001.xhtml',
        textId: 'f005',
      ),
      const SmilParallel(
        id: 'p000006',
        clipBegin: Duration(seconds: 15, milliseconds: 279),
        clipEnd: Duration(seconds: 18, milliseconds: 519),
        textFileName: 'p001.xhtml',
        textId: 'f006',
      ),
      const SmilParallel(
        id: 'p000007',
        clipBegin: Duration(seconds: 18, milliseconds: 519),
        clipEnd: Duration(seconds: 22, milliseconds: 760),
        textFileName: 'p001.xhtml',
        textId: 'f007',
      ),
      const SmilParallel(
        id: 'p000008',
        clipBegin: Duration(seconds: 22, milliseconds: 760),
        clipEnd: Duration(seconds: 25, milliseconds: 719),
        textFileName: 'p001.xhtml',
        textId: 'f008',
      ),
      const SmilParallel(
        id: 'p000009',
        clipBegin: Duration(seconds: 25, milliseconds: 719),
        clipEnd: Duration(seconds: 31, milliseconds: 239),
        textFileName: 'p001.xhtml',
        textId: 'f009',
      ),
      const SmilParallel(
        id: 'p000010',
        clipBegin: Duration(seconds: 31, milliseconds: 239),
        clipEnd: Duration(seconds: 34, milliseconds: 280),
        textFileName: 'p001.xhtml',
        textId: 'f010',
      ),
      const SmilParallel(
        id: 'p000011',
        clipBegin: Duration(seconds: 34, milliseconds: 280),
        clipEnd: Duration(seconds: 36, milliseconds: 960),
        textFileName: 'p001.xhtml',
        textId: 'f011',
      ),
      const SmilParallel(
        id: 'p000012',
        clipBegin: Duration(seconds: 36, milliseconds: 960),
        clipEnd: Duration(seconds: 40, milliseconds: 640),
        textFileName: 'p001.xhtml',
        textId: 'f012',
      ),
      const SmilParallel(
        id: 'p000013',
        clipBegin: Duration(seconds: 40, milliseconds: 640),
        clipEnd: Duration(seconds: 43, milliseconds: 600),
        textFileName: 'p001.xhtml',
        textId: 'f013',
      ),
      const SmilParallel(
        id: 'p000014',
        clipBegin: Duration(seconds: 43, milliseconds: 600),
        clipEnd: Duration(seconds: 48, milliseconds: 0),
        textFileName: 'p001.xhtml',
        textId: 'f014',
      ),
      const SmilParallel(
        id: 'p000015',
        clipBegin: Duration(seconds: 48, milliseconds: 0),
        clipEnd: Duration(seconds: 53, milliseconds: 280),
        textFileName: 'p001.xhtml',
        textId: 'f015',
      ),
    ];

    final parameterizedCases = getParameterizedCases(
      'test/resources/p001.xhtml.smil',
      'smil/body/seq',
      expectedValues,
    );

    parameterizedCases.forEach((element, expectedValue) {
      test('SmilParallel is parsed correctly', () {
        final smilParallel = SmilParallel.fromXmlElement(element);

        expect(smilParallel, equals(expectedValue));
      });
    });
  });
}
