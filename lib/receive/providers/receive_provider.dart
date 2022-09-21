import 'package:flutter/foundation.dart';
import 'package:network_info_plus/network_info_plus.dart';

class ReceiveProvider with ChangeNotifier {
  static NetworkInfo networkInfo = NetworkInfo();

  ReceiveProvider() {
    _fetchIpAddress();
  }

  void _fetchIpAddress() async {
    _ipAddress = await networkInfo.getWifiIP();
  }

  late String? _ipAddress;

  String get ipAddress{
    if(_ipAddress == null){
      return "";
    }
    return _ipAddress!;
  }
}
