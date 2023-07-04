import 'dart:convert';
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
    File? file = _file;
    if(file == null) return SendResult.lostFile;
    if(!(await file.exists())) return SendResult.lostFile;

    // connection
    String? id;
    try {
      id = await _sender.connect('$ip:${OptionManager().get(Params.port.toString()) ?? kDefaultPort}');
    }catch(e) {
      return SendResult.connectionFail;
    }
    if(id == null) return SendResult.connectionFail;

    // send
    try {
      await _sender.send(id, Uint8List.fromList(utf8.encode("file")));
    }
    catch(e){
      _sender.close();
      return SendResult.sendFail;
    }
    _sender.close();
    return SendResult.success;
  }

  void setOctet(int octet, int value){
    _ip[octet] = value;
  }

  set file(File? file) {
    _file = file;
    notifyListeners();
  }
}
