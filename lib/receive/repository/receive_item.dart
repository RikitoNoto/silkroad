import 'dart:typed_data';


import 'package:flutter/material.dart';


class ReceiveItem{
  ReceiveItem({
    required this.name,
    required Uint8List data,
    required this.sender,
    this.iconData = Icons.description,
  }){
    size = data.length;
    sizeStr = _convertSizeStr(size);
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

  final IconData iconData;            /// アイコンデータ
  final String name;                  /// ファイル名
  late final int size;                /// ファイルサイズ
  late final String sizeStr;          /// ファイルサイズ文字列
  final String sender;                /// 送信者名
}
