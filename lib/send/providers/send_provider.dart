import 'package:flutter/foundation.dart';

import 'package:platform/platform.dart';

class SendProvider with ChangeNotifier {
  SendProvider({required this.platform});

  final LocalPlatform platform;

  String get ip => _ip.join('.');
  final List<int> _ip = <int>[0, 0, 0, 0];

  void setOctet(int octet, int value){
    _ip[octet] = value;
  }
}
