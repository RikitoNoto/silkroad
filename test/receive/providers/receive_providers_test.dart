import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:platform/platform.dart';

import 'receive_providers_test.mocks.dart';

import 'package:silkroad/comm/communication_if.dart';
import 'package:silkroad/comm/tcp.dart';
import 'package:silkroad/receive/providers/receive_provider.dart';
import 'package:silkroad/utils/models/animated_list_item_model.dart';
import 'package:silkroad/receive/repository/receive_item.dart';
import '../../spy/path_provider_spy.dart';


late AnimatedListItemModel<ReceiveItem> kReceiveList;

@GenerateMocks([Tcp])
@GenerateMocks([Socket])
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MockTcp mockHost = MockTcp();
  MockSocket mockSocket = MockSocket();
  kReceiveList = AnimatedListItemModel<ReceiveItem>(
    listKey: GlobalKey<AnimatedListState>(),
    removedItemBuilder: (ReceiveItem item, int index, BuildContext context, Animation<double> animation) => const Text(''),
  );

  setUpAll((){
    PathProviderPlatformSpy.temporaryPath = kTempDir.path;
  });

  setUp(() async{
    await pathProviderSetUp();
    kReceiveList.clear();
  });

  tearDown(() async{
    await pathProviderTearDown();
  });

  // portTest(mockHost);
  callbackActionTest(mockHost, mockSocket);
  ipAddressTest();
  itemActionTest();
}

void ipAddressTest(){
  group('ip address test', () {
    test('should be not set ip address when the ip list is empty', () {
      ReceiveProvider kProvider = ReceiveProvider(receiveList: kReceiveList, platform: LocalPlatform());
      kProvider.overwriteAddressList(<String>[]);
      kProvider.selectIp('192.168.1.100');
      expect(kProvider.currentIp, '');
    });

    test('should be set ip address when the ip is include in the ip list', () {
      ReceiveProvider kProvider = ReceiveProvider(receiveList: kReceiveList, platform: LocalPlatform());
      kProvider.overwriteAddressList(<String>['192.168.1.100']);
      kProvider.selectIp('192.168.1.100');
      expect(kProvider.currentIp, '192.168.1.100');
    });

    test('should be return false when the ip is not include in the ip list(empty)', () {
      ReceiveProvider kProvider = ReceiveProvider(receiveList: kReceiveList, platform: LocalPlatform());
      kProvider.overwriteAddressList(<String>[]);
      expect(kProvider.isEnableIp('192.168.1.100'), isFalse);
    });

    test('should be return true when the ip is include in the ip list', () {
      ReceiveProvider kProvider = ReceiveProvider(receiveList: kReceiveList, platform: LocalPlatform());
      kProvider.overwriteAddressList(<String>['192.168.1.100']);
      expect(kProvider.isEnableIp('192.168.1.100'), isTrue);
    });
  });
}

ReceiveProvider? kProvider;
String? kIpAddressSpy;
ReceiveCallback<Socket>? kReceiveCallbackSpy;
int kPortSpy = 0;
void setupSpyComm(MockTcp mockHost){
  kIpAddressSpy = null;
  kPortSpy = 0;
  kReceiveCallbackSpy = null;
  while(kReceiveList.length != 0){
    kReceiveList.removeAt(0);
  }

  kProvider = ReceiveProvider(receiveList: kReceiveList, platform: LocalPlatform(), builder: (){
    // kIpAddressSpy = ipAddress;
    // kPortSpy = port;
    // kReceiveCallbackSpy = receiveCallback;
    return mockHost;
  });
}

Future<bool> openPort(String ip, int port, MockTcp mockHost, MockSocket mockSocket){
  kProvider!.overwriteAddressList(<String>[ip]);
  kProvider!.selectIp(ip);
  when(mockHost.listen(any, receiveCallback: captureAnyNamed('receiveCallback'), connectionCallback: anyNamed('connectionCallback'))).thenAnswer((_) => Future.value(mockSocket));
  kReceiveCallbackSpy = verify(mockHost.listen(any, receiveCallback: captureAnyNamed('receiveCallback'), connectionCallback: anyNamed('connectionCallback'))).captured.first;
 Future<bool> result = kProvider!.open();

  kReceiveCallbackSpy = verify(mockHost.listen(any, receiveCallback: captureAnyNamed('receiveCallback'), connectionCallback: anyNamed('connectionCallback'))).captured.first;
  return result;
}

Future<void> checkOpenPort(String ip, int port, bool providerOpenReturnValue, bool isCalled, MockTcp mockHost) async{

  when(mockHost.listen(any)).thenAnswer((_)=>Future<void>.value());
  verifyNever(mockHost.listen(any));
  bool result = await openPort(ip, port);
  if(isCalled) {
    verify(mockHost.listen('$ip:${port.toString()}'));
  }else{
    verifyNever(mockHost.listen(any));
  }

  // expect(kIpAddressSpy, ip);
  // expect(kPortSpy, port);
  expect(result, providerOpenReturnValue);
}

void portTest(MockTcp mockHost) {
  group('port open and close test', () {

    test('should be open port when call the open method', () async{
      setupSpyComm(mockHost);
      await checkOpenPort("192.168.1.1", ReceiveProvider.portNo, true, true, mockHost);
    });

    test('should be close port when call the close method', () async{
      setupSpyComm(mockHost);
      when(mockHost.close()).thenAnswer((_)=> Future.value(null));
      await checkOpenPort("192.168.1.1", ReceiveProvider.portNo, true, true, mockHost);
      verifyNever(mockHost.close());
      kProvider!.close();
      verify(mockHost.close());
    });
  });
}

Future<void> setupCallbackAction(MockTcp mockHost, {
  String ip = '192.168.1.1',
  int port = ReceiveProvider.portNo,
}) async{
  setupSpyComm(mockHost);
  await openPort(ip, port);
  if(kReceiveCallbackSpy == null) fail("did not set receive callback.");
}

Future checkReceiveListLen(int expectLen, String sendData, MockSocket mockSocket, MockTcp mockHost) async{
  // setupSpyComm(mockHost);
  // when(mockHost.listen(any, receiveCallback: captureAnyNamed('receiveCallback'), connectionCallback: anyNamed('connectionCallback'))).thenAnswer((_) => Future.value(mockSocket));
  // kProvider!.open();
  // kReceiveCallbackSpy = verify(mockHost.listen(any, receiveCallback: captureAnyNamed('receiveCallback'), connectionCallback: anyNamed('connectionCallback'))).captured.first;

  await kReceiveCallbackSpy!(mockSocket, Uint8List.fromList(utf8.encode(sendData)));
  expect(kReceiveList.length, expectLen);
}

String convertMessageString({required name, sender='', data=''}){
  return 'SEND_FILE\nname:$name\nsender:$sender\n\n$data';
}

void callbackActionTest(MockTcp mockHost, MockSocket mockSocket) {
  group('callback action test', () {
    // ReceiveProvider.networkInfo = networkInfoMock;

    test('should be not increment list len when receive no command.', () async{
      checkReceiveListLen(0, '', mockSocket, mockHost);
    });

    test('should be increment list len when receive send file command.', () async{
      await setupCallbackAction(mockHost);
      checkReceiveListLen(1, convertMessageString(name: 'A', data: '!'), mockSocket, mockHost);
    });

    test('should be set name to added item.', () async{
      await setupCallbackAction(mockHost);
      checkReceiveListLen(1, convertMessageString(name: 'A', data: '!'), mockSocket, mockHost);
      expect(kReceiveList[0].name, 'A');
    });

    test('should be set sender to added item.', () async{
      await setupCallbackAction(mockHost);
      await checkReceiveListLen(1, convertMessageString(name: 'senderTest', sender: 'sender'), mockSocket, mockHost);
      expect(kReceiveList[0].sender, 'sender');
    });

    test('should be set data to added item.', () async{
      await setupCallbackAction(mockHost);
      await checkReceiveListLen(1, convertMessageString(name: 'dataTest', data: 'test data'), mockSocket, mockHost);
      File tempFile = File(p.join((await getTemporaryDirectory()).path, 'dataTest'));
      String data = await tempFile.readAsString();

      expect(data, 'test data');
    });

    test('should be add to end item.', () async{
      await setupCallbackAction(mockHost);
      await checkReceiveListLen(1, convertMessageString(name: 'A', data: '!'), mockSocket, mockHost);
      await checkReceiveListLen(2, convertMessageString(name: 'B', data: '!'), mockSocket, mockHost);
      expect(kReceiveList[0].name, 'A');
      expect(kReceiveList[1].name, 'B');
    });
  });

}

void itemActionTest() {
  group('delete display by item action test', (){

    test('should be able to delete item.', () async{
      kReceiveList.append(ReceiveItem(name: 'name', data: Uint8List(0), sender: 'sender'));
      kProvider = ReceiveProvider(receiveList: kReceiveList, platform: LocalPlatform());
      kProvider!.removeAt(0);
      expect(kReceiveList.length, 0);
    });

    test('should be able to delete selected item.', () async{
      kReceiveList.append(ReceiveItem(name: 'no target', data: Uint8List(0), sender: 'sender'));
      kReceiveList.append(ReceiveItem(name: 'target', data: Uint8List(0), sender: 'sender'));
      kReceiveList.append(ReceiveItem(name: 'no target', data: Uint8List(0), sender: 'sender'));
      kProvider = ReceiveProvider(receiveList: kReceiveList, platform: LocalPlatform());
      kProvider!.removeAt(1);
      expect(kReceiveList.length, 2);
      expect(kReceiveList[0].name, 'no target');
      expect(kReceiveList[1].name, 'no target');
    });

  });

  group('save item action test', (){

    test('should be call save item in pc.', () async{

    });

  });
}
