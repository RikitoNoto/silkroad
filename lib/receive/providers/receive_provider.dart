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
  ReceiveProvider({required receiveList, this.builder = _build}) : _receiveList = receiveList
  {
    _addressList.add(_currentAddress);
    fetchIpAddresses();
  }
  static const portNo = 32099;
  final ReceiveHostFactoryFunc builder;
  HostIF? _hostComm;
  final AnimatedListItemModel _receiveList;
  String _currentAddress = '';
  final List<String> _addressList = <String>[];

  String get currentAddress => _currentAddress;
  List<String> get addressList => _addressList;

  static HostIF _build({
    required String ipAddress,
    required int port,
    ConnectionCallback? connectionCallback,
    ReceiveCallback? receiveCallback
  }){
    return TcpHost(ipAddress: ipAddress, port: port, connectionCallback: connectionCallback, receiveCallback: receiveCallback);
  }

  Future<bool> open() async{
    _hostComm = builder(ipAddress: currentAddress, port: portNo, receiveCallback: _onReceive);

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

  void selectAddress(String? address){
    if(address == null) return ;

    if(_addressList.contains(address)){
      _currentAddress = address;
      notifyListeners();
    }
  }

  void fetchIpAddresses() async {
    for(NetworkInterface interface in await NetworkInterface.list()){
      for(InternetAddress address in interface.addresses){
        if(address.type == InternetAddressType.IPv4) _addressList.add(address.address);
      }
    }
    notifyListeners();
  }

  void overwriteAddressList(List<String> addressList){
    if(kDebugMode){
      _addressList.clear();
      for(var address in addressList){
        _addressList.add(address);
      }
    }
  }
}
