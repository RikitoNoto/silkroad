import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:path/path.dart' as p;

import 'package:silkroad/comm/comm.dart';
import 'package:silkroad/send/providers/send_provider.dart';

import 'send_providers_test.mocks.dart';

late SendProvider kProvider;
late MockFile kFileMock;
late MockTcp kTcpMock;
late MockSocket kSocketMock;
late Message? kSendData;

CommunicationIF<Socket> _buildSpy(){
  return kTcpMock;
}

@GenerateMocks([Socket])
@GenerateMocks([Tcp])
@GenerateMocks([File])
void main() {
  setUp((){
    kSendData = null;
    kFileMock = MockFile();
    kTcpMock = MockTcp();
    kSocketMock = MockSocket();
    kProvider = SendProvider(builder: _buildSpy);
    kProvider.file = kFileMock;
  });
  ipTest();
  fileSetTest();
  sendMessageTest();
  fileNameTest();
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

void fileNameTest(){
  group('file name test', () {
    test('should be get file name [No select] when no file set', () {
      kProvider.file = null;
      expect(kProvider.fileName, 'No select');
    });

    test('should be get file name [temp.c] when set file temp/temp.c', () {
      when(kFileMock.path).thenAnswer((_) => p.join('temp', 'temp.c'));
      expect(kProvider.fileName, 'temp.c');
    });
  });
}

void setIpAddressToProvider(String ip){
  ip.split('.').asMap().forEach((int i, String octet) {
    kProvider.setOctet(i, int.parse(octet));
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
      setIpAddressToProvider('255.255.255.255');
      expect(kProvider.ip, '255.255.255.255');
    });
  });
}

void setupSendMocks({String fileName='name', bool isFileExist=true, Uint8List? data, Result sendResult=Result.success, bool connectionResult=true}){
  when(kFileMock.exists()).thenAnswer((_) => Future.value(isFileExist));
  when(kFileMock.path).thenAnswer((_) => p.join(fileName));
  when(kFileMock.readAsBytes()).thenAnswer((_) => Future.value(data ?? Uint8List(0)));
  when(kTcpMock.connect(any)).thenAnswer((_)=>Future.value(connectionResult ? kSocketMock : null));
  when(kTcpMock.send(any, any)).thenAnswer((Invocation invocation) {
    kSendData = invocation.positionalArguments[1];
    return Future.value(sendResult);
  });
  when(kTcpMock.close()).thenAnswer((_)=>Future.value(null));
}

void checkCalledSend({
  String expectIp='0.0.0.0',
  int expectPort=32099,
  Message? data,
  bool checkNever=false,
  bool checkNeverConnect=false,
  bool checkNeverSend=false,
  bool checkNeverClose=false,
}){
  if(checkNever) checkNeverConnect = checkNeverSend = checkNeverClose = checkNever;

  if(!checkNeverConnect) {
    verify(kTcpMock.connect('$expectIp:$expectPort'));
  }
  else{
    verifyNever(kTcpMock.connect(any));
  }

  if(!checkNeverSend){
    verify(kTcpMock.send(kSocketMock, any));
    if(data != null){
      expect(kSendData?.data, data.data);
    }
  }else{
    verifyNever(kTcpMock.send(any, any));
  }

  if(!checkNeverClose){
    verify(kTcpMock.close());
  }else{
    verifyNever(kTcpMock.close());
  }
}

void sendMessageTest(){
  group('send message test', () {
    test('should be connect and send to socket default', () async{
      setupSendMocks();
      expect(await kProvider.send(), isTrue);
      checkCalledSend(expectIp: '0.0.0.0', expectPort: 32099);
    });

    test('should be connect and send to socket [192.168.12.1]', () async{
      setupSendMocks();
      setIpAddressToProvider('192.168.12.1');
      expect(await kProvider.send(), isTrue);
      checkCalledSend(expectIp: '192.168.12.1', expectPort: 32099);
    });

    test('should be fail and not send message if file is none', () async{
      setupSendMocks(fileName: 'name', isFileExist: false);
      expect(await kProvider.send(), isFalse);
      checkCalledSend(checkNeverSend: true);
    });

    test('should be fail and not send message if connection is fail', () async{
      setupSendMocks(fileName: 'name', isFileExist: false, connectionResult: false);
      expect(await kProvider.send(), isFalse);
      checkCalledSend(checkNeverSend: true);
    });

    test('should be send message empty data when file data is empty', () async{
      setupSendMocks(fileName: 'name', data: Uint8List.fromList(utf8.encode('')));
      expect(await kProvider.send(), isTrue);
      checkCalledSend(data: SendFile.send(name: 'name', sender: '', fileData: Uint8List.fromList(utf8.encode(''))));
    });
  });
}
