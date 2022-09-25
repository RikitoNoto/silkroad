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
  }

  final IconData iconData;            /// アイコンデータ
  final String name;                  /// ファイル名
  late final int size;                     /// ファイルサイズ
  final String sender;                /// 送信者名
}
