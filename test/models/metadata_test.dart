import 'package:flutter_test/flutter_test.dart';
import 'package:epub_decoder/models/metadata.dart';

import '../matchers/null_or_empty.dart';

void main() {
  group('Metadata model testing', () {
    test('''Metadata.empty returns an instance where
        every attribute is null or empty''', () {
      final metadata = Metadata.empty;

      expect(metadata.isEmpty, true);
      expect(metadata.props, everyElement(isNullOrEmpty));
    });
  });
}
