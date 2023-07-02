import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:platform/platform.dart';

import 'package:silkroad/global.dart';
import 'package:silkroad/comm/comm.dart';
import 'package:silkroad/parameter.dart';
import 'package:silkroad/send/repository/send_repository.dart';
import 'package:silkroad/i18n/translations.g.dart';

enum SendResult{
  success,
  lostFile,
  connectionFail,
  sendFail,
}

extension SendResultMessage on SendResult{
  String get message{
    switch(this){
      case SendResult.success:
        return t.send.sendResult.success;

      case SendResult.lostFile:
        return t.send.sendResult.lostFile;

      case SendResult.connectionFail:
        return t.send.sendResult.connectionFail;

      case SendResult.sendFail:
        return t.send.sendResult.sendFail;
    }
  }
}


class SendProvider with ChangeNotifier, IpaddressFetcher {
  SendProvider({this.builder, required this.platform}) {
    fetchIpAddress();
    _sender = builder!();
  }

  static final String fileNameNoSelect = t.send.fileNone;

  final List<int> _ip = <int>[0, 0, 0, 0];
  final List<String> _addressRange = <String>[];
  File? _file;
  // final CommunicationFactoryFunc<Socket> builder;
  final SimpleFactoryFunc<SendRepository>? builder;
  final Platform platform;
  late final SendRepository _sender;

  String get filePath => _file?.path ?? '';
  String get ip => _ip.join('.');
  String get fileName {
    File? file = _file;
    return file != null ? p.basename(_file!.path) : fileNameNoSelect;
  }

  int get addressRangeCount => _addressRange.length;
  List<String> get addressRange => _addressRange;

  Future fetchIpAddress() async{
    _addressRange.clear();
    Set<String> addressRangeSet = <String>{};
    for(String address in await fetchIpv4Addresses(platform)){
      List<String> range = IpAddressUtility.getIpAddressRange(address);
      addressRangeSet.add('${range[0]}~${range[1]}');
    }
    _addressRange.addAll(addressRangeSet.toList());
    notifyListeners();
  }

  Future<SendResult> send() async{
    _sender.connect('$ip:${OptionManager().get(Params.port.toString()) ?? kDefaultPort}');

    return SendResult.success;
    //
    // SendResult sendResult = SendResult.success;
    // File? file = _file;
    // CommunicationIF<Socket>? communicator = builder();
    // Socket? socket;
    // try {
    //   socket = await communicator.connect(
    //       '$ip:${OptionManager().get(Params.port.toString()) ?? kDefaultPort}');
    // }
    // catch(e){
    //   sendResult = SendResult.connectionFail;
    // }
    //
    // // connection is success
    // if(socket != null){
    //   // file is exist
    //   if( (file != null) && (await file.exists())) {
    //     Object? sender = OptionManager().get(Params.name.toString());
    //     try {
    //       await communicator.send(socket, SendFile.send(
    //           name: p.basename(file.path),
    //           sender: sender?.toString() ?? '',
    //           fileData: await file.readAsBytes()));
    //       // sendResult = true;
    //     }catch(e){
    //       sendResult = SendResult.sendFail;
    //     }
    //
    //   }
    //   else{
    //     sendResult = SendResult.lostFile;
    //   }
    //
    //   await communicator.close();
    // }
    // else{
    //   sendResult = SendResult.connectionFail;
    // }
    //
    // return sendResult;
  }

  void setOctet(int octet, int value){
    _ip[octet] = value;
  }

  set file(File? file) {
    _file = file;
    notifyListeners();
  }
}
