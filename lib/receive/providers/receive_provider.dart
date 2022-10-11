import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:platform/platform.dart';
import 'package:silkroad/comm/communication_if.dart';

import 'package:silkroad/comm/communication_if.dart';
import 'package:silkroad/comm/tcp.dart';
import 'package:silkroad/comm/message.dart';
import 'package:silkroad/utils/models/animated_list_item_model.dart';
import 'package:silkroad/receive/repository/receive_item.dart';
import 'package:silkroad/utils/platform_saver.dart';

typedef ReceiveHostFactoryFunc = CommunicationIF Function({
  required String ipAddress,
  required int port,
  ConnectionCallback<Socket>? connectionCallback,
  ReceiveCallback<Socket>? receiveCallback,
});

class ReceiveProvider with ChangeNotifier {
  ReceiveProvider({required this.platform, required receiveList, this.builder = _build}) : _receiveList = receiveList
  {
    _ipList.add(_currentIp);
    fetchIpAddresses();
  }
  static const portNo = 32099;
  final ReceiveHostFactoryFunc builder;
  CommunicationIF? _hostComm;
  final AnimatedListItemModel _receiveList;
  final Platform platform;


  String _currentIp = '';                   /// selected ip address
  String get currentIp => _currentIp;

  final List<String> _ipList = <String>[];  /// ip address list
  List<String> get ipList => _ipList;

  static CommunicationIF _build({
    required String ipAddress,
    required int port,
    ConnectionCallback<Socket>? connectionCallback,
    ReceiveCallback<Socket>? receiveCallback
  }){
    return Tcp(ipAddress: ipAddress, port: port, connectionCallback: connectionCallback, receiveCallback: receiveCallback);
  }

  Future<bool> open() async{
    _hostComm = builder(ipAddress: currentIp, port: portNo, receiveCallback: _onReceive);

    _hostComm!.listen();
    return true;
  }

  void close(){
    _hostComm?.close();
  }

  /// change [_currentIp].
  /// if [address] is not contain in [_ipList],
  /// this method not set [_currentIp].
  /// only when contain [_ipList],
  /// notify to lister the change.
  void selectIp(String? address){
    if(address == null) return ;

    if(isEnableIp(address)){
      _currentIp = address;
      notifyListeners();
    }
  }

  void fetchIpAddresses() async {
    for(NetworkInterface interface in await NetworkInterface.list()){
      for(InternetAddress address in interface.addresses){
        if(address.type == InternetAddressType.IPv4) _ipList.add(address.address);
      }
    }
    notifyListeners();
  }

  /// check to enable the ip address.
  bool isEnableIp(String address){
    return address != '' && _ipList.contains(address);
  }

  void save(int index) async {
    ReceiveItem item = _receiveList[index];
    await PlatformSaverIF(platform: platform).save(item.tempPath);
    removeAt(index);
  }

  void removeAt(int index){
    _receiveList.removeAt(index);
  }

  void _onReceive(Socket socket, Uint8List data) {
    Message message = Message(data);
    if(message is SendFile){
      ReceiveItem item = ReceiveItem(
        name: message.name,
        data: message.fileData,
        sender: message.sender,
      );
      _receiveList.append(item);
    }
  }

  /// for debug
  void overwriteAddressList(List<String> addressList){
    if(kDebugMode){
      _ipList.clear();
      for(var address in addressList){
        _ipList.add(address);
      }
    }
  }
}
