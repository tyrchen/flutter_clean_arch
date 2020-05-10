import 'dart:io';

String fixture(String name) {
  final String path = 'fixture/$name';
  if (FileSystemEntity.typeSync(path) != FileSystemEntityType.notFound) {
    return File(path).readAsStringSync();
  }
  return File('test/$path').readAsStringSync();
}
