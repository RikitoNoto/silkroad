import 'package:flutter/foundation.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:silkroad/comm/host_if.dart';
import 'package:silkroad/comm/tcp_host.dart';

typedef ReceiveHostFactoryFunc = HostIF Function({
  required String ipAddress,
  required int port,
  ConnectionCallback? connectionCallback,
  ReceiveCallback? receiveCallback
});

class ReceiveProvider with ChangeNotifier {
  static NetworkInfo networkInfo = NetworkInfo();
  late final ReceiveHostFactoryFunc builder;
  String? _ipAddress;
  HostIF? _hostComm;


  static HostIF _build({
    required String ipAddress,
    required int port,
    ConnectionCallback? connectionCallback,
    ReceiveCallback? receiveCallback
  }){
    return TcpHost(ipAddress: ipAddress, port: port, connectionCallback: connectionCallback, receiveCallback: receiveCallback);
  }

  ReceiveProvider({ReceiveHostFactoryFunc builder = _build}) {
    this.builder = builder;
    _fetchIpAddress();
    // if(_ipAddress != null){
    //   _hostComm = this.builder(ipAddress: _ipAddress!, port: 1);
    // }
  }

  Future<void> open() async{
    // if(_hostComm == null){
    //   _fetchIpAddress();
    //   while(_ipAddress == null){}
    //
    //   _hostComm = builder(ipAddress: _ipAddress!, port: 1);
    // }

    _ipAddress ??= await networkInfo.getWifiIP();

    _hostComm = builder(ipAddress: _ipAddress!, port: 1);

    _hostComm!.listen();
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
