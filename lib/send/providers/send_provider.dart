import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:platform/platform.dart';

import 'package:silkroad/comm/communication_if.dart';
import 'package:silkroad/comm/tcp.dart';

typedef SendClientFactoryFunc = CommunicationIF Function({
  required String ipAddress,
  required int port,
  ConnectionCallback<Socket>? connectionCallback,
  ReceiveCallback<Socket>? receiveCallback,
});

class SendProvider with ChangeNotifier {
  SendProvider({required this.platform, this.builder = _build});

  final LocalPlatform platform;
  final List<int> _ip = <int>[0, 0, 0, 0];
  File? _file;
  final SendClientFactoryFunc builder;
  CommunicationIF? communicator;

  String get filePath => _file?.path ?? '';
  String get ip => _ip.join('.');

  static CommunicationIF _build({
    required String ipAddress,
    required int port,
    ConnectionCallback<Socket>? connectionCallback,
    ReceiveCallback<Socket>? receiveCallback
  }){
    return Tcp(ipAddress: ipAddress, port: port, connectionCallback: connectionCallback, receiveCallback: receiveCallback);
  }

  Future send() async{
    // communicator = builder(ipAddress: ip, port:)
  }

  void setOctet(int octet, int value){
    _ip[octet] = value;
  }

  set file(File? file) {
    _file = file;
  }
}
