import 'dart:io';

import 'package:flutter/foundation.dart';
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
  ReceiveCallback? receiveCallback,
});

class ReceiveProvider with ChangeNotifier {
  ReceiveProvider({required receiveList, this.builder = _build}) : _receiveList = receiveList;
  static const portNo = 32099;
  final ReceiveHostFactoryFunc builder;
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

  Future<bool> open(String ipAddress) async{
    _hostComm = builder(ipAddress: ipAddress, port: portNo, receiveCallback: _onReceive);

    _hostComm!.listen();
    return true;
  }

  void close(){
    _hostComm?.close();
  }

  void _onReceive(Socket socket, Uint8List data) {
    Message message = Message(data);

    if(message is SendFile){
      ReceiveItem item = ReceiveItem(
        name: message.name,
        data: message.fileData,
        sender: message.sender,
      );
      _receiveList.insert(_receiveList.length, item);
    }
  }

  void fetchIpAddresses(List<String> addressList) async {
    addressList.clear();
    for(NetworkInterface interface in await NetworkInterface.list()){
      for(InternetAddress address in interface.addresses){
        addressList.add(address.address);
      }
    }
  }
}
