import 'dart:io';

mixin IpaddressFetcher {
  Future<List<String>> fetchIpv4Addresses() async {
    List<String> addressList = <String>[];
    for(NetworkInterface interface in await NetworkInterface.list()){
      for(InternetAddress address in interface.addresses){
        if(address.type == InternetAddressType.IPv4) addressList.add(address.address);
      }
    }
    return addressList;
  }
}
