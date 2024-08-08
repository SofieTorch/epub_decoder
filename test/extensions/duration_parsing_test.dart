import 'package:flutter_test/flutter_test.dart';
import 'package:epub_decoder/extensions/duration_parsing.dart';

void main() {
  test(
      'Duration().fromString creates a new Duration from a String with format hh:mm:ss.ms',
      () {
    final parameterizedCases = {
      '0:00:53.320': const Duration(seconds: 53, milliseconds: 320),
      '0:01:46.270': const Duration(minutes: 1, seconds: 46, milliseconds: 270),
      '0:00:00.000': const Duration(seconds: 0),
      '0:00:59.999': const Duration(seconds: 59, milliseconds: 999),
    };

    parameterizedCases.forEach((input, expectedValue) {
      final parsedDuration = const Duration().fromString(input);
      expect(parsedDuration, expectedValue);
    });
  });
}
