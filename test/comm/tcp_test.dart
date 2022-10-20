import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'tcp_test.mocks.dart';

import 'package:silkroad/comm/comm.dart';

late MockSocket kSocketMock;
late Tcp kReceiver;
late Tcp kSender;
late Message? kReceiveData;
String? kSendData;

@GenerateMocks([Socket])
void main() {
  setUp((){
    kSender = Tcp();
    kReceiver = Tcp();
    kSocketMock = MockSocket();
    kReceiveData = null;

    when(kSocketMock.write(any)).thenAnswer((realInvocation) {
      kSendData = realInvocation.positionalArguments.first;
    });
  });

  tearDown((){
    kSender.close();
    kReceiver.close();
  });

  sendAndReceiveTest();
}

void receiveSpy(Socket socket, Message data){
  kReceiveData = data;
}

Future checkSendAndReceiveData({int port=50000, int waitReceiveTimeMs=10, String dataName='', String dataSender='', required Uint8List data,}) async{
  await kReceiver.listen('127.0.0.1:$port', receiveCallback: receiveSpy);

  Socket? connection = await kSender.connect('127.0.0.1:$port');
  expect(connection == null, isFalse);  // sender should be connect to receiver.

  await kSender.send(connection!, SendFile.send(name: dataName, sender: dataSender, fileData: data));

  await Future.delayed(Duration(milliseconds: waitReceiveTimeMs));
  expect(kReceiveData is SendFile, isTrue);                               // should be receive SendFile Message.
  expect(kReceiveData?.getDataStr(SendFile.dataIndexName), dataName);     // should be receive the data name.
  expect(kReceiveData?.getDataStr(SendFile.dataIndexSender), dataSender); // should be receive the data sender.
  expect(kReceiveData!.getDataBin(SendFile.dataIndexFile).length, data.length);  // should be same receive data length and send data length.
  // should be receive data is same of expect data.
  Uint8List receiveFileData = kReceiveData!.getDataBin(SendFile.dataIndexFile);
  for(int i=0; i<data.length; i++){
    expect(receiveFileData[i], data[i]);
  }
}

Uint8List createDataFromSize(int size){
  List<int> data = <int>[];
  for(int i=0; i<size; i++){
    data.add(0x00);
  }
  return Uint8List.fromList(data);
}

void sendAndReceiveTest(){

  group('send and receive test', (){
    test('should be send and receive data one byte.', () async {
      await checkSendAndReceiveData(data: createDataFromSize(1));
    });

    test('should be send and receive data 65536 byte.', () async {
      await checkSendAndReceiveData(data: createDataFromSize(65536));
    });

    test('should be send and receive data 65537 byte.', () async {
      await checkSendAndReceiveData(data: createDataFromSize(65537));
    });

    test('should be send and receive data 524288 byte.', () async {
      await checkSendAndReceiveData(data: createDataFromSize(524288), waitReceiveTimeMs: 100);
    });

    test('should be send and receive data 65536 byte include header.', () async {
      Message data = SendFile.send(name: '', sender: '', fileData: Uint8List(0));
      await checkSendAndReceiveData(data: createDataFromSize(65536 - utf8.encode(data.data).length));
    });
  });
}
