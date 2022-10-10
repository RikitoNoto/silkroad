import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'package:silkroad/utils/file_analyzer.dart';

/// receive item class.
class ReceiveItem{
  static const int _sizeBase = 1024;
  static const List<String> _sizeUnit = <String>['B', 'KB', 'MB', 'GB', 'TB'];

  late final IconData iconData;
  final String name;                  /// file name
  late final int size;                /// file size
  late final String sizeStr;          /// file size string
  final String sender;

  ReceiveItem({required this.name, required Uint8List data, required this.sender, IconData? iconData,}){
    size = data.length;
    sizeStr = _convertSizeStr(size);
    _setIcon(iconData);
    _createTempFile(name: name, data: data);
  }

  void _setIcon(IconData? iconData){
    // if there is the icon arg.
    if(iconData != null){
      this.iconData = iconData; // set the arg icon.
    }
    // if there is no icon arg and can convert an icon from the name.
    else if(FileAnalyzer.convertIcon(name) != null){
      this.iconData = FileAnalyzer.convertIcon(name)!; // set the convert result.
    }
    // don't know icon.
    else{
      this.iconData = Icons.description;  // set description icon.
    }
  }

  Future _createTempFile({required name, required Uint8List data}) async{
    File tempFile = File(p.join((await getTemporaryDirectory()).path, name));
    await tempFile.create();

    await tempFile.writeAsBytes(data);

  }

  static String _convertSizeStr(int size){
    String sizeStr;
    int expCount = 0;

    while(size >= _sizeBase){
      size = size ~/ _sizeBase;
      expCount++;
    }
    sizeStr = '$size${_sizeUnit[expCount]}';
    return sizeStr;
  }

}
