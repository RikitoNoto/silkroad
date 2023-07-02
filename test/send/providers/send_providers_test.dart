import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:path/path.dart' as p;
import 'package:platform/platform.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:silkroad/comm/comm.dart';
import 'package:silkroad/option/option_manager.dart';
import 'package:silkroad/send/providers/send_provider.dart';
import 'package:silkroad/send/repository/send_repository.dart';
import 'package:silkroad/option/params.dart';

import 'send_providers_test.mocks.dart';

late SendProvider kProvider;
late MockFile kFileMock;
late MockTcp kTcpMock;
late MockSocket kSocketMock;
late Message? kSendData;
late Map<String, Object> kParamMap;

CommunicationIF<Socket> _buildSpy(){
  return kTcpMock;
}

Future setParam(String key , Object value) async{
  kParamMap[key] = value;
  SharedPreferences.setMockInitialValues(kParamMap);
  await OptionManager.initialize();
}

@GenerateMocks([SendRepository])
@GenerateMocks([Socket])
@GenerateMocks([Tcp])
@GenerateMocks([File])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(()async{
    kSendData = null;
    kFileMock = MockFile();
    kTcpMock = MockTcp();
    kSocketMock = MockSocket();
    kProvider = SendProvider(platform: const LocalPlatform(), builder: ()=>MockSendRepository());
    kProvider.file = kFileMock;
    kParamMap = <String, Object>{};
    await setParam(Params.port.toString(), 32099);
    await setParam(Params.name.toString(), '');
  });
  tearDown(()async{
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

void setIpAddressToProvider(String ip, {SendProvider? provider}){
  provider ??= kProvider;
  ip.split('.').asMap().forEach((int i, String octet) {
    provider?.setOctet(i, int.parse(octet));
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

Future setupSendMocks({String fileName='name', bool isFileExist=true, Uint8List? data, Result sendResult=Result.success, bool connectionResult=true, String? sender}) async{
  when(kFileMock.exists()).thenAnswer((_) => Future.value(isFileExist));
  when(kFileMock.path).thenAnswer((_) => p.join(fileName));
  when(kFileMock.readAsBytes()).thenAnswer((_) => Future.value(data ?? Uint8List(0)));
  when(kTcpMock.connect(any)).thenAnswer((_)=>Future.value(connectionResult ? kSocketMock : null));
  when(kTcpMock.send(any, any)).thenAnswer((Invocation invocation) {
    kSendData = invocation.positionalArguments[1];
    return Future.value(sendResult);
  });
  when(kTcpMock.close()).thenAnswer((_)=>Future.value(null));
  await setParam(Params.name.toString(), sender ?? '');
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

SendProvider constructProvider({
  Platform? platform,
  SendRepository? repository,
}){
  return SendProvider(
    platform: platform ?? const LocalPlatform(),
    builder: (){
      return repository ?? MockSendRepository();
    },
  );
}

void sendMessageTest(){
  group('connect test', () {
      test('should be to call the connect method with default end point', () async{
        MockSendRepository mockRepo = MockSendRepository();
        SendProvider provider = constructProvider(repository: mockRepo);
        when(mockRepo.connect(any)).thenAnswer((_) => Future.value("connection_id_1"));
        await provider.send();

        verify(mockRepo.connect("0.0.0.0:32099"));
      });

      test('should be to call the connect method with args end point', () async{
        MockSendRepository mockRepo = MockSendRepository();
        SendProvider provider = constructProvider(repository: mockRepo);
        setParam(Params.port.toString(), 32100);
        setIpAddressToProvider("1.1.1.1", provider: provider);
        when(mockRepo.connect(any)).thenAnswer((_) => Future.value("connection_id_1"));
        await provider.send();

        verify(mockRepo.connect("1.1.1.1:32099"));
      });
  });
  //   test('should be connect and send to socket [192.168.12.1]', () async{
  //     await setupSendMocks();
  //     setIpAddressToProvider('192.168.12.1');
  //     expect(await kProvider.send(), SendResult.success);
  //     checkCalledSend(expectIp: '192.168.12.1', expectPort: 32099);
  //   });
  //
  //   test('should be fail and not send message if file is none', () async{
  //     await setupSendMocks(fileName: 'name', isFileExist: false);
  //     expect(await kProvider.send(), SendResult.lostFile);
  //     checkCalledSend(checkNeverSend: true);
  //   });
  //
  //   test('should be fail and not send message if connection is fail', () async{
  //     await setupSendMocks(fileName: 'name', isFileExist: false, connectionResult: false);
  //     expect(await kProvider.send(), SendResult.connectionFail);
  //     checkCalledSend(checkNeverSend: true, checkNeverClose: true);
  //   });
  //
  //   test('should be send message empty data when file data is empty', () async{
  //     await setupSendMocks(fileName: 'name', data: Uint8List.fromList(utf8.encode('')));
  //     expect(await kProvider.send(), SendResult.success);
  //     checkCalledSend(data: SendFile.send(name: 'name', sender: '', fileData: Uint8List.fromList(utf8.encode(''))));
  //   });
  //
  //   test('should be send message sender when option name is set [senderA]', () async{
  //     await setupSendMocks(fileName: 'name', sender: 'senderA', data: Uint8List.fromList(utf8.encode('')));
  //     expect(await kProvider.send(), SendResult.success);
  //     checkCalledSend(data: SendFile.send(name: 'name', sender: 'senderA', fileData: Uint8List.fromList(utf8.encode(''))));
  //   });
  //
  //   test('should be change port number[33333]', () async{
  //     await setParam(Params.port.toString(), 33333);
  //     await setupSendMocks(fileName: 'name', data: Uint8List.fromList(utf8.encode('')));
  //     expect(await kProvider.send(), SendResult.success);
  //     checkCalledSend(expectPort: 33333, data: SendFile.send(name: 'name', sender: '', fileData: Uint8List.fromList(utf8.encode(''))));
  //   });
  //
  //   test('should be send default port [32099] when not set port ', () async{
  //     (await SharedPreferences.getInstance()).remove(Params.port.toString());
  //     await setupSendMocks(fileName: 'name', data: Uint8List.fromList(utf8.encode('')));
  //     expect(await kProvider.send(), SendResult.success);
  //     checkCalledSend(expectPort: 32099, data: SendFile.send(name: 'name', sender: '', fileData: Uint8List.fromList(utf8.encode(''))));
  //   });
  //
  //   test('should be return fail if fail connection.', () async{
  //     await setupSendMocks();
  //     when(kTcpMock.connect(any)).thenAnswer((_)=>throw const SocketException('fail'));
  //     try{expect(await kProvider.send(), SendResult.connectionFail);}
  //     catch (e){fail('could not catch exception in send method.');}
  //     checkCalledSend(checkNeverSend: true, checkNeverClose: true,);
  //   });
  //
  //   test('should be return fail if fail send.', () async{
  //     await setupSendMocks();
  //     when(kTcpMock.send(any, any)).thenAnswer((_)=>throw const SocketException('fail'));
  //     try{expect(await kProvider.send(), SendResult.sendFail);}
  //     catch (e){fail('could not catch exception in send method.');}
  //     checkCalledSend();
  //   });
  // });
}
