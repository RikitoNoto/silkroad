import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:platform/platform.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:silkroad/comm/tcp.dart';
import 'package:silkroad/comm/communication_if.dart';
import 'package:silkroad/send/providers/send_provider.dart';

import 'send_providers_test.mocks.dart';

late SendProvider kProvider;
late MockFile kFileMock;
late MockTcp kTcpMock;

CommunicationIF _buildSpy({
  required String ipAddress,
  required int port,
  ConnectionCallback<Socket>? connectionCallback,
  ReceiveCallback<Socket>? receiveCallback
}){
  return kTcpMock;
}

@GenerateMocks([Tcp])
@GenerateMocks([File])
void main() {
  setUp((){
    kFileMock = MockFile();
    kTcpMock = MockTcp();
    kProvider = SendProvider(platform: const LocalPlatform(), builder: _buildSpy);
  });
  ipTest();
  fileSetTest();
  sendMessageTest();
}

void sendMessageTest(){
  group('send message test', () {
    test('should be send message', () {
      //TODO: create connection method in tcp
      //      that can not send message because it unknown send to.
      // kProvider.send();
    });
  });
}

void fileSetTest(){
  group('file set test', () {
    test('should be able to set file and get file path', () {
      kProvider.file = File('');
      expect(kProvider.filePath, '');
    });

    test('should be change file path [A]', () {
      kProvider.file = File('A');
      expect(kProvider.filePath, 'A');
    });

    test('should be change file path [file]', () {
      kProvider.file = File('file');
      expect(kProvider.filePath, 'file');
    });
  });
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
