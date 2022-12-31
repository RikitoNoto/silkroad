import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:platform/platform.dart';

import 'package:silkroad/comm/communication_if.dart';
import 'package:silkroad/comm/message.dart';
import 'package:silkroad/comm/ipaddress_utility.dart';
import 'package:silkroad/utils/models/animated_list_item_model.dart';
import 'package:silkroad/receive/models/receive_item.dart';
import 'package:silkroad/utils/platform_saver.dart';
import 'package:silkroad/parameter.dart';
import 'package:silkroad/global.dart';


class ReceiveProvider with ChangeNotifier, IpaddressFetcher{
  ReceiveProvider({required this.platform, required AnimatedListItemModel receiveList, this.builder = kCommunicationFactory}) : _receiveList = receiveList
  {
    _ipList.add(_currentIp);
    fetchIpAddresses();
  }
  final CommunicationFactoryFunc<Socket> builder;
  CommunicationIF<Socket>? _hostComm;
  final AnimatedListItemModel _receiveList;
  final Platform platform;


  String _currentIp = '';                   /// selected ip address
  String get currentIp => _currentIp;

  final List<String> _ipList = <String>[];  /// ip address list
  List<String> get ipList => _ipList;

  Future<bool> open() async{
    _hostComm = builder();

    await _hostComm!.listen('$currentIp:${OptionManager().get(Params.port.toString()) ?? kDefaultPort}', receiveCallback: _onReceive);
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
    _ipList.addAll(await fetchIpv4Addresses(platform));
    notifyListeners();
  }

  /// check to enable the ip address.
  bool isEnableIp(String address){
    return address != '' && _ipList.contains(address);
  }

  void save(int index) async {
    ReceiveItem item = _receiveList[index];
    if(await PlatformSaverIF(platform: platform).save(item.tempPath)){
      removeAt(index);
    }
  }

  void removeAt(int index){
    _receiveList.removeAt(index);
  }

  void _onReceive(Socket socket, Message data) {
    if(data is SendFile){
      ReceiveItem item = ReceiveItem(
        name: data.name,
        data: data.fileData,
        sender: data.sender,
      );
      _receiveList.append(item);
    }
  }

  @visibleForTesting
  void overwriteAddressList(List<String> addressList){
    if(kDebugMode){
      _ipList.clear();
      for(var address in addressList){
        _ipList.add(address);
      }
    }
  }
}
