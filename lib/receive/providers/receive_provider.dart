import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:silkroad/comm/host_if.dart';
import 'package:silkroad/comm/tcp_host.dart';
import 'package:silkroad/comm/message.dart';
import 'package:silkroad/utils/models/animated_list_item_model.dart';
import 'package:silkroad/receive/repository/receive_item.dart';

typedef ReceiveHostFactoryFunc = HostIF Function({
  required String ipAddress,
  required int port,
  ConnectionCallback? connectionCallback,
  ReceiveCallback? receiveCallback
});

class ReceiveProvider with ChangeNotifier {
  ReceiveProvider({required receiveList, this.builder = _build}) : _receiveList = receiveList {
    _fetchIpAddress();
  }
  static const portNo = 32099;
  static NetworkInfo networkInfo = NetworkInfo();
  final ReceiveHostFactoryFunc builder;
  String? _ipAddress;
  HostIF? _hostComm;
  final AnimatedListItemModel _receiveList;


  static HostIF _build({
    required String ipAddress,
    required int port,
    ConnectionCallback? connectionCallback,
    ReceiveCallback? receiveCallback
  }){
    return TcpHost(ipAddress: ipAddress, port: port, connectionCallback: connectionCallback, receiveCallback: receiveCallback);
  }

  Future<bool> open() async{

    _ipAddress ??= await networkInfo.getWifiIP();

    if(_ipAddress == null){
      return false;
    }

    _hostComm = builder(ipAddress: _ipAddress!, port: portNo, receiveCallback: _onReceive);

    _hostComm!.listen();
    return true;
  }

  void close(){
    _hostComm?.close();
  }

  void _onReceive(Socket socket, Uint8List data) {
    Message message = Message.convert(data);

    if(message is SendFile){
      ReceiveItem item = ReceiveItem(
        iconData: Icons.text_snippet_outlined,
        name: message.getDataStr(SendFile.dataIndexName),
        data: Uint8List(0),
        sender: socket.toString(),
      );
      _receiveList.insert(_receiveList.length, item);
    }
  }

  void _fetchIpAddress() async {
    _ipAddress = await networkInfo.getWifiIP();
  }


  String get ipAddress{
    if(_ipAddress == null){
      return "";
    }
    return _ipAddress!;
  }
}
