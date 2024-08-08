import 'package:epub_decoder/models/lazy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Value is not initialized until it is invoked', () {
    final lazy = Lazy<int>(() => 42);
    expect(lazy.isInitialized, false);

    lazy.value;
    expect(lazy.isInitialized, true);
  });

  test('Value of an invoked instance is different than a non-invoked', () {
    final lazy1 = Lazy<int>(() => 42);
    final lazy2 = Lazy<int>(() => 42);
    expect(lazy1, equals(lazy2));
    expect(lazy1.hashCode, equals(lazy2.hashCode));

    lazy1.value;
    expect(lazy1, isNot(equals(lazy2)));
    expect(lazy1.hashCode, isNot(equals(lazy2.hashCode)));
  });

  test('toString() returns the expected string representation', () {
    final lazy = Lazy<int>(() => 42);
    expect(
      lazy.toString(),
      equals({'value': null, 'isInitialized': false}.toString()),
    );

    lazy.value;
    expect(
      lazy.toString(),
      equals({'value': 42, 'isInitialized': true}.toString()),
    );
  });
}
