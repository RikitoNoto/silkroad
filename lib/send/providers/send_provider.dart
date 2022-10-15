import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:path/path.dart' as p;
import 'package:platform/platform.dart';

import 'package:silkroad/comm/comm.dart';
import 'package:silkroad/comm/communication_if.dart';
import 'package:silkroad/comm/tcp.dart';

typedef SendClientFactoryFunc<T> = CommunicationIF<T> Function();

class SendProvider with ChangeNotifier {
  SendProvider({required this.platform, this.builder = _build});

  final LocalPlatform platform;
  final List<int> _ip = <int>[0, 0, 0, 0];
  File? _file;
  final SendClientFactoryFunc<Socket> builder;
  // CommunicationIF<Socket>? communicator;

  String get filePath => _file?.path ?? '';
  String get ip => _ip.join('.');

  static CommunicationIF<Socket> _build(){
    return Tcp();
  }

  Future<bool> send() async{
    bool sendResult = false;
    File? file = _file;
    CommunicationIF<Socket>? communicator = builder();

    Socket? socket = await communicator.connect('$ip:32099');

    // connection is success and
    // file is exist
    if( (socket != null) &&
        (file != null) &&
        (await file.exists())){

      await communicator.send(socket, SendFile.send(name: p.basename(file.path), sender: '', fileData: await file.readAsBytes()));
      sendResult = true;
    }

    await communicator.close();
    return sendResult;
  }

  void setOctet(int octet, int value){
    _ip[octet] = value;
  }

  set file(File? file) {
    _file = file;
  }
}
