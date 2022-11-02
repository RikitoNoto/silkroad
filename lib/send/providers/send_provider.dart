import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import 'package:silkroad/global.dart';
import 'package:silkroad/comm/comm.dart';
import 'package:silkroad/parameter.dart';
import 'package:silkroad/i18n/translations.g.dart';


class SendProvider with ChangeNotifier {
  SendProvider({this.builder = kCommunicationFactory});

  static final String fileNameNoSelect = t.send.fileNone;

  final List<int> _ip = <int>[0, 0, 0, 0];
  File? _file;
  final CommunicationFactoryFunc<Socket> builder;

  String get filePath => _file?.path ?? '';
  String get ip => _ip.join('.');
  String get fileName {
    File? file = _file;
    return file != null ? p.basename(_file!.path) : fileNameNoSelect;
  }

  Future<bool> send() async{

    bool sendResult = false;
    File? file = _file;
    CommunicationIF<Socket>? communicator = builder();
    Socket? socket;
    try {
      socket = await communicator.connect(
          '$ip:${OptionManager().get(Params.port.toString()) ?? kDefaultPort}');
    }
    catch(e){
      ;
    }

    // connection is success
    if(socket != null){
      // file is exist
      if( (file != null) && (await file.exists())) {
        Object? sender = OptionManager().get(Params.name.toString());
        try {
          await communicator.send(socket, SendFile.send(
              name: p.basename(file.path),
              sender: sender?.toString() ?? '',
              fileData: await file.readAsBytes()));
          sendResult = true;
        }catch(e){
          ;
        }

      }

      await communicator.close();
    }
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
