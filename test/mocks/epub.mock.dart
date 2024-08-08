import 'package:archive/archive.dart';
import 'package:epub_decoder/epub.dart';
import 'package:mockito/mockito.dart';

class MockArchive extends Mock implements Archive {}

// ignore: must_be_immutable
class MockEpub extends Mock implements Epub {
  @override
  final Archive zip = MockArchive();
}
