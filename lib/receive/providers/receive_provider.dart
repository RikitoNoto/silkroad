import 'package:flutter/foundation.dart';
import 'package:network_info_plus/network_info_plus.dart';

class ReceiveProvider with ChangeNotifier {
  static NetworkInfo networkInfo = NetworkInfo();

  ReceiveProvider()
  {
    setIpaddress();
  }

  void setIpaddress() async
  {
    _ipaddress = await networkInfo.getWifiIP();
  }

  String? _ipaddress;

  String? get ipaddress{
    return _ipaddress;
  }
}
