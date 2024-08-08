import 'package:flutter_test/flutter_test.dart';

Matcher isNullOrEmpty = predicate((value) {
  final isNull = value == null;
  final isEmptyIterable = value is Iterable && value.isEmpty;
  final isEmptyString = value is String && value.isEmpty;

  return isNull || isEmptyIterable || isEmptyString;
}, 'is null or empty');
