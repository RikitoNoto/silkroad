import 'dart:typed_data';

import 'package:flutter/material.dart';


class ReceiveItem{
  ReceiveItem({
    required this.iconData,
    required this.name,
    required Uint8List data,
    required this.sender,
  }){
    size = data.length;
    if(size / 1024 >= 1){
      sizeStr = '${(size/1024).toInt()}KB';
    }else{
      sizeStr = '${size}B';
    }
  }

  final IconData iconData;            /// アイコンデータ
  final String name;                  /// ファイル名
  late final int size;                /// ファイルサイズ
  late final String sizeStr;          /// ファイルサイズ文字列
  final String sender;                /// 送信者名
}
