import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

Directory kSpyRootDir = Directory(p.join('test','temp'));
Directory kTempDir = Directory(p.join(kSpyRootDir.path, 'temp'));

Future constructSpyDirTree() async{
  await kSpyRootDir.create(recursive: true);
  await kTempDir.create(recursive: true);
}

Future deleteSpyDirTree() async{
  await kSpyRootDir.delete(recursive: true);
}

Future pathProviderSetUp() async{
  await constructSpyDirTree();
  PathProviderPlatformSpy();
}

Future pathProviderTearDown() async{
  await Future.delayed(const Duration(milliseconds: 5));  // wait to finish file thread.
  await deleteSpyDirTree();
}

class PathProviderPlatformSpy extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {

  static String temporaryPath = 'temporaryPath';
  static String applicationSupportPath = 'applicationSupportPath';
  static String downloadsPath = 'downloadsPath';
  static String libraryPath = 'libraryPath';
  static String applicationDocumentsPath = 'applicationDocumentsPath';
  static String externalCachePath = 'externalCachePath';
  static String externalStoragePath = 'externalStoragePath';

  PathProviderPlatformSpy(){
    PathProviderPlatform.instance = this;
  }

  @override
  Future<String?> getTemporaryPath() async {
    return temporaryPath;
  }

  @override
  Future<String?> getApplicationSupportPath() async {
    return applicationSupportPath;
  }

  @override
  Future<String?> getLibraryPath() async {
    return libraryPath;
  }

  @override
  Future<String?> getApplicationDocumentsPath() async {
    return applicationDocumentsPath;
  }

  @override
  Future<String?> getExternalStoragePath() async {
    return externalStoragePath;
  }

  @override
  Future<List<String>?> getExternalCachePaths() async {
    return <String>[externalCachePath];
  }

  @override
  Future<List<String>?> getExternalStoragePaths({
    StorageDirectory? type,
  }) async {
    return <String>[externalStoragePath];
  }

  @override
  Future<String?> getDownloadsPath() async {
    return downloadsPath;
  }
}
