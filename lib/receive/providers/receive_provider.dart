import 'package:flutter/foundation.dart';
import 'package:platform/platform.dart';

import 'package:silkroad/comm/ipaddress_utility.dart';
import 'package:silkroad/utils/models/animated_list_item_model.dart';
import 'package:silkroad/receive/entity/receive_item.dart';
import 'package:silkroad/receive/repository/receive_repository.dart';
import 'package:silkroad/utils/platform_saver.dart';
import 'package:silkroad/parameter.dart';
import 'package:silkroad/global.dart';


class ReceiveProvider with ChangeNotifier, IpaddressFetcher{
  //TODO: delete required of builder.
  ReceiveProvider({required this.platform, required AnimatedListItemModel receiveList, required this.builder}) : _receiveList = receiveList
  {
    _ipList.add(_currentIp);
    fetchIpAddresses();
    _receiver = builder();
  }
  final SimpleFactoryFunc<ReceiveRepository> builder;
  final AnimatedListItemModel _receiveList;
  final Platform platform;
  late final ReceiveRepository _receiver;


  String _currentIp = '';                   /// selected ip address
  String get currentIp => _currentIp;

  final List<String> _ipList = <String>[];  /// ip address list
  List<String> get ipList => _ipList;

  Future open() async{
    String endPoint = '$currentIp:${OptionManager().get(Params.port.toString()) ?? kDefaultPort}';
    await for(ReceiveItem item in _receiver.listen(endPoint)){
      _receiveList.append(item);
    }
  }

  void close(){
    _receiver.close();
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
