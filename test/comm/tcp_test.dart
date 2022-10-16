import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'tcp_test.mocks.dart';

import 'package:silkroad/comm/comm.dart';

late MockSocket kSocketMock;
late Tcp kTcp;
Object? kSendData;

@GenerateMocks([Socket])
void main() {
  setUp((){
    kTcp = Tcp();
    kSocketMock = MockSocket();
  });
  sendTest();
}

void sendTest(){
  group('send test', () {
    test('should be send data.', () async {
      when(kSocketMock.write(any)).thenAnswer((realInvocation) {
        kSendData = realInvocation.positionalArguments.first;
      });
      Message sendMessage = SendFile.send(name: '', sender: '', fileData: Uint8List.fromList([]));
      await kTcp.send(kSocketMock, sendMessage);
      expect(kSendData, sendMessage.data);
    });
  });
}
