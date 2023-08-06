import 'dart:io';
import 'dart:typed_data';

import 'package:platform/platform.dart';
import 'package:network_info_plus/network_info_plus.dart';

export 'package:lan_scanner/lan_scanner.dart' show Host;

mixin IpaddressFetcher {
  Future<List<String>> fetchIpv4Addresses(Platform platform) async {
    if (platform.isAndroid) {
      return _fetchIpv4AddressesForAndroid();
    } else {
      return _fetchIpv4AddressesForPcAndIos();
    }
  }

  Future<List<String>> _fetchIpv4AddressesForAndroid() async {
    List<String> addressList = <String>[];
    String? ip = await NetworkInfo().getWifiIP();
    if (ip != null) {
      addressList.add(ip);
    }
    return addressList;
  }

  Future<List<String>> _fetchIpv4AddressesForPcAndIos() async {
    List<String> addressList = <String>[];
    for (NetworkInterface interface in await NetworkInterface.list()) {
      for (InternetAddress address in interface.addresses) {
        if (address.type == InternetAddressType.IPv4) {
          addressList.add(address.address);
        }
      }
    }
    return addressList;
  }

  String getNetworkAddress(String ipAddress, int subnet) {
    final addressList = ipAddress.split(".");
    final octet = subnet / 8; // target octet

    final List<String> networkAddressList = [];
    for (int i = 0; i < octet; i++) {
      // if it isn't target octet, add a raw data.
      if (i < octet - 1) {
        networkAddressList.add(addressList[i]);

        // if it is target octet, convert to binary and count bits.
      } else {
        final bin = int.parse(addressList[i])
            .toRadixString(2)
            .padLeft(8, "0"); // convert binary

        if (subnet % 8 == 0) {
          networkAddressList.add(int.parse(bin, radix: 2).toString());
        } else {
          networkAddressList.add(
              int.parse(bin.substring(0, subnet % 8).padRight(8, "0"), radix: 2)
                  .toString());
        }
      }
    }

    return networkAddressList.join(".");
  }
}

class IpAddressUtility {
  static List<String> getIpAddressRange(String ipAddress) {
    List<int> rawAddress = convertRawAddress(ipAddress);

    /// 192.168.0.0 ~ 192.168.255.255
    if ((rawAddress[0] == 192) && (rawAddress[1] == 168)) {
      return <String>['192.168.0.0', '192.168.255.255'];
    }

    /// 172.16.0.0 ~ 172.31.255.255
    if ((rawAddress[0] == 172) &&
        (rawAddress[1] >= 16) &&
        (rawAddress[1] <= 31)) {
      return <String>['172.16.0.0', '172.31.255.255'];
    }

    /// 10.0.0.0 ~ 10.255.255.255
    if ((rawAddress[0] == 10)) {
      return <String>['10.0.0.0', '10.255.255.255'];
    }

    return <String>[];
  }

  static Uint8List convertRawAddress(String ipAddress) {
    return Uint8List.fromList(
        ipAddress.split('.').map((value) => int.parse(value)).toList());
  }
}
