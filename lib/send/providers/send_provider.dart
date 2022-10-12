import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:platform/platform.dart';

class SendProvider with ChangeNotifier {
  SendProvider({required this.platform});

  final LocalPlatform platform;
  final List<int> _ip = <int>[0, 0, 0, 0];
  File? _file;

  String get filePath => _file?.path ?? '';
  String get ip => _ip.join('.');

  void setOctet(int octet, int value){
    _ip[octet] = value;
  }

  set file(File? file) {
    _file = file;
  }
}
