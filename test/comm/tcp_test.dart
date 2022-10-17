import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'tcp_test.mocks.dart';

import 'package:silkroad/comm/comm.dart';

late MockSocket kSocketMock;
late Tcp kTcp;
String? kSendData;

@GenerateMocks([Socket])
void main() {
  setUp((){
    kTcp = Tcp();
    kSocketMock = MockSocket();

    when(kSocketMock.write(any)).thenAnswer((realInvocation) {
      kSendData = realInvocation.positionalArguments.first;
    });
  });
  sendTest();
}


void sendTest(){
  group('send test', () {
    test('should be send data.', () async {
      Message sendMessage = SendFile.send(name: '', sender: '', fileData: Uint8List.fromList([]));
      await kTcp.send(kSocketMock, sendMessage);
      expect(kSendData, sendMessage.data);
    });

    test('should be convert send data before send [0x00, 0x01].', () async {
      Message sendMessage = SendFile.send(name: '', sender: '', fileData: Uint8List.fromList([0x00, 0x01]));
      await kTcp.send(kSocketMock, sendMessage);
      Message sendData = Message(Uint8List.fromList(utf8.encode(kSendData!)));
      expect(sendData is SendFile, isTrue);
      expect(sendData.getDataBin(SendFile.dataIndexFile), Uint8List.fromList([0x00, 0x01]));
    });

    test('should be convert send data before send 4096byte [0x00].', () async {
      List<int> data = [];
      for(int i=0; i<4096; i++){
        data.add(0x00);
      }

      Message sendMessage = SendFile.send(name: '', sender: '', fileData: Uint8List.fromList(data));
      await kTcp.send(kSocketMock, sendMessage);
      Message sendData = Message(Uint8List.fromList(utf8.encode(kSendData!)));
      expect(sendData is SendFile, isTrue);

      Uint8List sendBin = sendData.getDataBin(SendFile.dataIndexFile);

      expect(sendBin.length, data.length);
      for(int i=0; i<4096; i++){
        expect(sendBin[i], data[i]);
      }
    });
  });
}
