import 'package:flutter/material.dart';

class ReceiveItemInfo{
  const ReceiveItemInfo({
    required this.iconData,
    required this.name,
    required this.size,
    required this.sender,
  });

  final IconData iconData;            /// アイコンデータ
  final String name;                  /// ファイル名
  final int size;                     /// ファイルサイズ
  final String sender;                /// 送信者名
}
