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
import 'receive_providers_test.mocks.dart';

import 'package:silkroad/comm/host_if.dart';
import 'package:silkroad/comm/tcp_host.dart';
import 'package:silkroad/receive/providers/receive_provider.dart';
import 'package:silkroad/utils/models/animated_list_item_model.dart';
import 'package:silkroad/receive/repository/receive_item.dart';
import '../../spy/path_provider_spy.dart';


late AnimatedListItemModel<ReceiveItem> kReceiveList;

@GenerateMocks([TcpHost])
@GenerateMocks([Socket])
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MockTcpHost mockHost = MockTcpHost();
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
  });

  tearDown(() async{
    await pathProviderTearDown();
  });

  // ipAddressTest(networkInfoMock);
  portTest(mockHost);
  callbackActionTest(mockHost, mockSocket);
}
//
//
// void checkIpAddress(MockNetworkInfo mock, String? returnValue, String expectAddress) async {
//   when(mock.getWifiIP()).thenAnswer((_)=>Future<String?>.value(returnValue));
//   ReceiveProvider kProvider = ReceiveProvider(receiveList: kReceiveList);
//   await mock.getWifiIP();      // for wait complete.
//   expect(kProvider.ipAddress, expectAddress);
// }
//
// void ipAddressTest(MockNetworkInfo networkInfoMock) {
//
//   ReceiveProvider.networkInfo = networkInfoMock;
//
//   group('receive kProvider ip fetch test', () {
//
//     test('should be get the ip address when initialize(0.0.0.0)', () {
//       checkIpAddress(networkInfoMock, "0.0.0.0", "0.0.0.0");
//     });
//
//     test('should be get the ip address when initialize(255.255.255.255)', () async {
//       checkIpAddress(networkInfoMock, "255.255.255.255", "255.255.255.255");
//     });
//
//     test('should be get empty string when did not get ip address', () async {
//       checkIpAddress(networkInfoMock, null, "");
//     });
//   });
// }

ReceiveProvider? kProvider;
String? kIpAddressSpy;
ReceiveCallback? kReceiveCallbackSpy;
int kPortSpy = 0;
void setupSpyComm(MockTcpHost mockHost){
  kIpAddressSpy = null;
  kPortSpy = 0;
  kReceiveCallbackSpy = null;
  while(kReceiveList.length != 0){
    kReceiveList.removeAt(0);
  }

  kProvider = ReceiveProvider(receiveList: kReceiveList, builder: ({
    required String ipAddress,
    required int port,
    ConnectionCallback? connectionCallback,
    ReceiveCallback? receiveCallback
  }){
    kIpAddressSpy = ipAddress;
    kPortSpy = port;
    kReceiveCallbackSpy = receiveCallback;
    return mockHost;
  });
}

Future<bool> openPort(String ip, int port){
  // when(networkInfoMock.getWifiIP()).thenAnswer((_)=>Future<String?>.value(ip));
  return kProvider!.open(ip);
}

Future<void> checkOpenPort(String ip, int port, bool providerOpenReturnValue, bool isCalled, MockTcpHost mockHost) async{

  when(mockHost.listen()).thenAnswer((_)=>Future<void>.value());
  verifyNever(mockHost.listen());
  bool result = await openPort(ip, port);
  if(isCalled) {
    verify(mockHost.listen());
  }else{
    verifyNever(mockHost.listen());
  }

  expect(kIpAddressSpy, ip);
  expect(kPortSpy, port);
  expect(result, providerOpenReturnValue);
}

void portTest(MockTcpHost mockHost) {
  group('port open and close test', () {
    // ReceiveProvider.networkInfo = networkInfoMock;

    test('should be open port when call the open method', () async{
      setupSpyComm(mockHost);
      await checkOpenPort("192.168.1.1", ReceiveProvider.portNo, true, true, mockHost);
    });

    // test('should be not open port when did not get ip address', () async{
    //   setupSpyComm(mockHost);
    //   await checkOpenPort(null, 0, false, false, networkInfoMock, mockHost);
    // });

    test('should be close port when call the close method', () async{
      setupSpyComm(mockHost);
      when(mockHost.close()).thenAnswer((_)=> {null});
      await checkOpenPort("192.168.1.1", ReceiveProvider.portNo, true, true, mockHost);
      verifyNever(mockHost.close());
      kProvider!.close();
      verify(mockHost.close());
    });
  });
}

Future<void> setupCallbackAction(MockTcpHost mockHost, {
  String ip = '192.168.1.1',
  int port = ReceiveProvider.portNo,
}) async{
  setupSpyComm(mockHost);
  await openPort(ip, port);
  if(kReceiveCallbackSpy == null) fail("did not set receive callback.");
}

Future checkReceiveListLen(int expectLen, String sendData, MockSocket mockSocket) async{
  await kReceiveCallbackSpy!(mockSocket, Uint8List.fromList(utf8.encode(sendData)));
  expect(kReceiveList.length, expectLen);
}

String convertMessageString({required name, sender='', data=''}){
  return 'SEND_FILE\nname:$name\nsender:$sender\n\n$data';
}

void callbackActionTest(MockTcpHost mockHost, MockSocket mockSocket) {
  group('callback action test', () {
    // ReceiveProvider.networkInfo = networkInfoMock;

    test('should be not increment list len when receive no command.', () async{
      checkReceiveListLen(0, '', mockSocket);
    });

    test('should be increment list len when receive send file command.', () async{
      await setupCallbackAction(mockHost);
      checkReceiveListLen(1, convertMessageString(name: 'A', data: '!'), mockSocket);
    });

    test('should be set name to added item.', () async{
      await setupCallbackAction(mockHost);
      checkReceiveListLen(1, convertMessageString(name: 'A', data: '!'), mockSocket);
      expect(kReceiveList[0].name, 'A');
    });

    test('should be set sender to added item.', () async{
      await setupCallbackAction(mockHost);
      await checkReceiveListLen(1, convertMessageString(name: 'senderTest', sender: 'sender'), mockSocket);
      expect(kReceiveList[0].sender, 'sender');
    });

    test('should be set data to added item.', () async{
      await setupCallbackAction(mockHost);
      await checkReceiveListLen(1, convertMessageString(name: 'dataTest', data: 'test data'), mockSocket);
      File tempFile = File(p.join((await getTemporaryDirectory()).path, 'dataTest'));
      String data = await tempFile.readAsString();

      expect(data, 'test data');
    });

    test('should be add to end item.', () async{
      await setupCallbackAction(mockHost);
      await checkReceiveListLen(1, convertMessageString(name: 'A', data: '!'), mockSocket);
      await checkReceiveListLen(2, convertMessageString(name: 'B', data: '!'), mockSocket);
      expect(kReceiveList[0].name, 'A');
      expect(kReceiveList[1].name, 'B');
    });
  });
}

