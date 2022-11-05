import 'package:flutter_test/flutter_test.dart';
import 'package:silkroad/comm/ipaddress_utility.dart';


void main() {
  subnetMaskRangeTest();
}

void checkIpAddressRange(String address, {String? from, String? until}){
  List<String> range = IpAddressUtility.getIpAddressRange(address);
  int length = 0;
  from != null ? length++ : null;
  until != null ? length++ : null;

  expect(range.length, length);
  if(from != null) expect(range[0], from);
  if(until != null) expect(range[1], until);
}

void subnetMaskRangeTest() {
  group('subnet mask range test', () {
    test('should be get no item list as the subnet mask from string function when pass the address [0.0.0.0] as an argument.', () async {
      checkIpAddressRange('0.0.0.0', );
    });

    /// 192.168.0.0 ~ 192.168.255.255
    test('should be get [192.168.0.0, 192.168.255.255] as the subnet mask from string function when pass the address [192.168.0.0] as an argument.', () async {
      checkIpAddressRange('192.168.0.0', from: '192.168.0.0', until: '192.168.255.255');
    });

    test('should be get [192.168.0.0, 192.168.255.255] as the subnet mask from string function when pass the address [192.168.100.0] as an argument.', () async {
      checkIpAddressRange('192.168.100.0', from: '192.168.0.0', until: '192.168.255.255');
    });

    test('should be get [192.168.0.0, 192.168.255.255] as the subnet mask from string function when pass the address [192.168.255.0] as an argument.', () async {
      checkIpAddressRange('192.168.255.255', from: '192.168.0.0', until: '192.168.255.255');
    });

    test('should be get no item list as the subnet mask from string function when pass the address [192.169.0.0] as an argument.', () async {
      checkIpAddressRange('192.169.0.0',);
    });

    test('should be get no item list as the subnet mask from string function when pass the address [192.167.0.0] as an argument.', () async {
      checkIpAddressRange('192.167.0.0',);
    });

    test('should be get no item list as the subnet mask from string function when pass the address [191.168.0.0] as an argument.', () async {
      checkIpAddressRange('191.168.0.0',);
    });

    test('should be get no item list as the subnet mask from string function when pass the address [193.168.0.0] as an argument.', () async {
      checkIpAddressRange('193.168.0.0',);
    });

    /// 172.16.0.0 ~ 172.31.255.255
    test('should be get [172.16.0.0, 172.31.255.255] as the subnet mask from string function when pass the address [172.16.0.0] as an argument.', () async {
      checkIpAddressRange('172.16.0.0', from: '172.16.0.0', until: '172.31.255.255');
    });

    test('should be get [172.16.0.0, 172.31.255.255] as the subnet mask from string function when pass the address [172.17.255.255] as an argument.', () async {
      checkIpAddressRange('172.17.255.255', from: '172.16.0.0', until: '172.31.255.255');
    });

    test('should be get [172.16.0.0, 172.31.255.255] as the subnet mask from string function when pass the address [172.30.199.213] as an argument.', () async {
      checkIpAddressRange('172.30.199.213', from: '172.16.0.0', until: '172.31.255.255');
    });

    test('should be get [172.16.0.0, 172.31.255.255] as the subnet mask from string function when pass the address [172.31.255.255] as an argument.', () async {
      checkIpAddressRange('172.31.255.255', from: '172.16.0.0', until: '172.31.255.255');
    });

    test('should be get no item list as the subnet mask from string function when pass the address [172.32.0.0] as an argument.', () async {
      checkIpAddressRange('172.32.0.0',);
    });

    test('should be get no item list as the subnet mask from string function when pass the address [171.31.0.0] as an argument.', () async {
      checkIpAddressRange('171.31.0.0',);
    });

    test('should be get no item list as the subnet mask from string function when pass the address [173.31.0.0] as an argument.', () async {
      checkIpAddressRange('173.31.0.0',);
    });

    /// 10.0.0.0 ~ 10.255.255.255
    test('should be get [10.0.0.0, 10.255.255.255] as the subnet mask from string function when pass the address [10.0.0.0] as an argument.', () async {
      checkIpAddressRange('10.0.0.0', from: '10.0.0.0', until: '10.255.255.255');
    });

    test('should be get [10.0.0.0, 10.255.255.255] as the subnet mask from string function when pass the address [10.173.100.65] as an argument.', () async {
      checkIpAddressRange('10.173.100.65', from: '10.0.0.0', until: '10.255.255.255');
    });

    test('should be get [10.0.0.0, 10.255.255.255] as the subnet mask from string function when pass the address [10.255.255.255] as an argument.', () async {
      checkIpAddressRange('10.255.255.255', from: '10.0.0.0', until: '10.255.255.255');
    });

    test('should be get no item list as the subnet mask from string function when pass the address [9.0.0.0] as an argument.', () async {
      checkIpAddressRange('9.0.0.0', );
    });

    test('should be get no item list as the subnet mask from string function when pass the address [11.0.0.0] as an argument.', () async {
      checkIpAddressRange('11.0.0.0', );
    });
  });
}
