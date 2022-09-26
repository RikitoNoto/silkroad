import 'dart:typed_data';


import 'package:flutter/material.dart';
import 'package:silkroad/utils/suffix_to_Icon_converter.dart';


class ReceiveItem{
  ReceiveItem({
    required this.name,
    required Uint8List data,
    required this.sender,
    IconData? iconData,
  }){
    size = data.length;
    sizeStr = _convertSizeStr(size);
    // if there is the icon arg.
    if(iconData != null){
      this.iconData = iconData; // set the arg icon.
    }
    // if there is no icon arg and can convert an icon from the name.
    else if(SuffixToIconConverter.convertIcon(name) != null){
      this.iconData = SuffixToIconConverter.convertIcon(name)!; // set the convert result.
    }
    // can't know icon.
    else{
      this.iconData = Icons.description;  // set description icon.
    }
  }
  static const int _sizeBase = 1024;
  static const List<String> _sizeUint = <String>['B', 'KB', 'MB', 'GB', 'TB'];

  static String _convertSizeStr(int size){
    String sizeStr;
    int expCount = 0;

    while(size >= _sizeBase){
      size = size ~/ _sizeBase;
      expCount++;
    }
    sizeStr = '${size}${_sizeUint[expCount]}';
    return sizeStr;
  }

  late final IconData iconData;            /// アイコンデータ
  final String name;                  /// ファイル名
  late final int size;                /// ファイルサイズ
  late final String sizeStr;          /// ファイルサイズ文字列
  final String sender;                /// 送信者名
}
