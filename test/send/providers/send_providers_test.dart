import 'package:flutter_test/flutter_test.dart';
import 'package:platform/platform.dart';

import 'package:silkroad/send/providers/send_provider.dart';

late SendProvider kProvider;

void main() {
  setUp((){
    kProvider = SendProvider(platform: const LocalPlatform());
  });
  ipTest();
}

void ipTest(){

  group('ip address test', () {
    test('should be get ip address default 0.0.0.0', () {
      expect(kProvider.ip, '0.0.0.0');
    });

    test('should be able to set octet 1 to 255', () {
      kProvider.setOctet(0, 255);
      expect(kProvider.ip, '255.0.0.0');
    });

    test('should be able to set octet 2 to 255', () {
      kProvider.setOctet(1, 255);
      expect(kProvider.ip, '0.255.0.0');
    });

    test('should be able to set octet 3 to 255', () {
      kProvider.setOctet(2, 255);
      expect(kProvider.ip, '0.0.255.0');
    });

    test('should be able to set octet 4 to 255', () {
      kProvider.setOctet(3, 255);
      expect(kProvider.ip, '0.0.0.255');
    });

    test('should be able to set all octets to 255', () {
      kProvider.setOctet(0, 255);
      kProvider.setOctet(1, 255);
      kProvider.setOctet(2, 255);
      kProvider.setOctet(3, 255);
      expect(kProvider.ip, '255.255.255.255');
    });
  });
}
