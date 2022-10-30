import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import 'package:silkroad/global.dart';
import 'package:silkroad/comm/comm.dart';
import 'package:silkroad/parameter.dart';

typedef SendClientFactoryFunc<T> = CommunicationIF<T> Function();

class SendProvider with ChangeNotifier {
  SendProvider({this.builder = _build});

  static const String fileNameNoSelect = 'No select';

  final List<int> _ip = <int>[0, 0, 0, 0];
  File? _file;
  final SendClientFactoryFunc<Socket> builder;

  String get filePath => _file?.path ?? '';
  String get ip => _ip.join('.');
  String get fileName {
    File? file = _file;
    return file != null ? p.basename(_file!.path) : fileNameNoSelect;
  }

  //TODO: move global.
  static CommunicationIF<Socket> _build(){
    return Tcp();
  }

  Future<bool> send() async{
    bool sendResult = false;
    File? file = _file;
    CommunicationIF<Socket>? communicator = builder();

    Socket? socket = await communicator.connect('$ip:${OptionManager().get(Params.port.toString()) ?? kDefaultPort}');

    // connection is success and
    // file is exist
    if( (socket != null) &&
        (file != null) &&
        (await file.exists())){

      Object? sender = OptionManager().get(Params.name.toString());
      await communicator.send(socket, SendFile.send(name: p.basename(file.path), sender: sender?.toString() ?? '', fileData: await file.readAsBytes()));
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
    notifyListeners();
  }
}
