import 'package:flutter_test/flutter_test.dart';

import 'null_or_empty.dart';

void main() {
  test('null or empty test', () {
    expect(null, isNullOrEmpty);
    expect('', isNullOrEmpty);
    expect('not empty', isNot(isNullOrEmpty));
    expect([], isNullOrEmpty);
    expect([1, 2, 3], isNot(isNullOrEmpty));
  });
}
