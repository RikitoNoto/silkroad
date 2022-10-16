import 'dart:io';

import 'package:gallery_saver/gallery_saver.dart';
import 'package:platform/platform.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:silkroad/utils/file_analyzer.dart';

abstract class PlatformSaverIF{
  factory PlatformSaverIF({required Platform platform}){
    PlatformSaverIF saver;
    switch(platform.operatingSystem){
      case Platform.android:
      case Platform.iOS:
        saver = MobileSaver();
        break;
      case Platform.windows:
      case Platform.macOS:
      case Platform.linux:
      case Platform.fuchsia:
        saver = PcSaver();
        break;
      default:
        throw UnSupportedDeviceException(platform.operatingSystem);
        break;
    }

    return saver;
  }

  Future<bool> save(String path);
}

class MobileSaver implements PlatformSaverIF{
  @override
  Future<bool> save(String path) async {
    switch(FileAnalyzer.getFileType(p.basename(path))){
      /// if the file is image
      case DiscreteType.image:
        GallerySaver.saveImage(path);
        break;

      /// if the file is video
      case DiscreteType.video:
        GallerySaver.saveVideo(path);
        break;
      default:
        String? _localPath = (await getExternalStorageDirectories(type: StorageDirectory.downloads))?.first.path;
        if(_localPath != null) {
          File file = File(p.join(_localPath, p.basename(path)));
          await file.writeAsBytes((await File(path).readAsBytes()));
        }

        break;
    }
    return await true;
  }
}

class PcSaver implements PlatformSaverIF{
  @override
  Future<bool> save(String path) async {
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: p.basename(path),
    );

    if(outputFile != null){
      await File(outputFile).writeAsBytes((await File(path).readAsBytes()));
    }
    return outputFile != null;
  }
}

class UnSupportedDeviceException implements Exception{
  UnSupportedDeviceException(this.device);
  String device;
}
