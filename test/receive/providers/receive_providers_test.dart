import 'dart:async';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silkroad/receive/providers/providers.dart';

import 'receive_providers_test.mocks.dart';

import 'package:silkroad/comm/communication_if.dart';
import 'package:silkroad/receive/repository/receive_repository.dart';
import 'package:silkroad/utils/models/animated_list_item_model.dart';
import 'package:silkroad/receive/entity/receive_item.dart';
import 'package:silkroad/parameter.dart';
import 'package:camel/camel.dart';
import '../../spy/path_provider_spy.dart';


late AnimatedListItemModel<ReceiveItem> kReceiveList;
late ReceiveProvider kProvider;

ReceiveCallback<Socket>? kReceiveCallbackSpy;

void setPort(int port){
  SharedPreferences.setMockInitialValues(<String, Object>{Params.port.toString(): port});
}

@GenerateMocks([ReceiveRepository])
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUpAll((){
    kReceiveList = AnimatedListItemModel<ReceiveItem>(
      listKey: GlobalKey<AnimatedListState>(),
      removedItemBuilder: (ReceiveItem item, int index, BuildContext context, Animation<double> animation) => const Text(''),
    );
    PathProviderPlatformSpy.temporaryPath = kTempDir.path;
  });

  setUp(() async{
    await pathProviderSetUp();
    kReceiveList.clear();
    // kProvider = ReceiveProvider(
    //   receiveList: kReceiveList,
    //   platform: LocalPlatform(),
    //
    // );

    kReceiveCallbackSpy = null;
    setPort(32099);
    await OptionManager.initialize();
  });

  tearDown(() async{
    await pathProviderTearDown();
  });

  // callbackActionTest();
  ipAddressTest();
  itemActionTest();
  portTest();
}

void ipAddressTest(){
  // group('ip address test', () {
  //   test('should be not set ip address when the ip list is empty', () {
  //     kProvider.overwriteAddressList(<String>[]);
  //     kProvider.selectIp('192.168.1.100');
  //     expect(kProvider.currentIp, '');
  //   });
  //
  //   test('should be set ip address when the ip is include in the ip list', () {
  //     kProvider.overwriteAddressList(<String>['192.168.1.100']);
  //     kProvider.selectIp('192.168.1.100');
  //     expect(kProvider.currentIp, '192.168.1.100');
  //   });
  //
  //   test('should be return false when the ip is not include in the ip list(empty)', () {
  //     kProvider.overwriteAddressList(<String>[]);
  //     expect(kProvider.isEnableIp('192.168.1.100'), isFalse);
  //   });
  //
  //   test('should be return true when the ip is include in the ip list', () {
  //     kProvider.overwriteAddressList(<String>['192.168.1.100']);
  //     expect(kProvider.isEnableIp('192.168.1.100'), isTrue);
  //   });
  // });
}

Future<ReceiveCallback<Socket>?> openPort(String ip, int port) async{
  kProvider.overwriteAddressList(<String>[ip]);
  kProvider.selectIp(ip);

  if(!await kProvider.open()) fail('fail open');
  return kReceiveCallbackSpy;
}

void checkOpenPort(MockReceiveRepository repo, ReceiveProvider provider, String ip, int port, bool isCalled, List<ReceiveItem> receiveSpy){
  StreamController<ReceiveItem> streamController = StreamController<ReceiveItem>();

  // construct listen mock.
  when(repo.listen(any)).thenAnswer((_) {
    for(ReceiveItem item in receiveSpy){
      streamController.sink.add(item);
    }
    return streamController.stream;
  });

  // set ip address
  provider.overwriteAddressList([ip]);
  provider.selectIp(ip);
  setPort(port);

  provider.open();

  if(isCalled){
    verify(repo.listen('$ip:$port'));
  }
}
//TODO: add Test => after should be increase _receiveList's item.

void portTest() {
  group('port open and close test', () {

    test('should be open port when call the open method', () async{
      MockReceiveRepository mockRepo = MockReceiveRepository();
      ReceiveProvider provider = ReceiveProvider(
        receiveList: kReceiveList,
        platform: LocalPlatform(),
        builder: (){
          return mockRepo;
        },
      );
      checkOpenPort(mockRepo, provider, "192.168.1.1", 32099, true, []);
    });

    test('should be open port when call the open method [1000]', () async{
      setPort(1000);
      await OptionManager.initialize();
      MockReceiveRepository mockRepo = MockReceiveRepository();
      ReceiveProvider provider = ReceiveProvider(
        receiveList: kReceiveList,
        platform: LocalPlatform(),
        builder: (){
          return mockRepo;
        },
      );
      checkOpenPort(mockRepo, provider, "192.168.1.1", 1000, true, []);
    });

    test('should be open port when parameter is null', () async{
      (await SharedPreferences.getInstance()).remove(Params.port.toString());
      // await OptionManager.initialize();
      MockReceiveRepository mockRepo = MockReceiveRepository();
      ReceiveProvider provider = ReceiveProvider(
        receiveList: kReceiveList,
        platform: LocalPlatform(),
        builder: (){
          return mockRepo;
        },
      );
      checkOpenPort(mockRepo, provider, "192.168.1.1", 32099, true, []);
    });

    // test('should be close port when call the close method', () async{
    //   when(kMockHost.close()).thenAnswer((_)=> Future.value(null));
    //   await checkOpenPort("192.168.1.1", 32099, true, true, kMockHost);
    //   verifyNever(kMockHost.close());
    //   kProvider.close();
    //   verify(kMockHost.close());
    // });
  });
}

Future<void> setupCallbackAction({
  String ip = '192.168.1.1',
  int port = 32099,
}) async{
  kReceiveCallbackSpy = await openPort(ip, port);
  if(kReceiveCallbackSpy == null) fail("could not get receive callback.");
}

// Future checkReceiveListLen(int expectLen, String sendData) async{//, MockSocket mockSocket, MockTcp mockHost) async{
//   await kReceiveCallbackSpy!(kMockSocket, Message(Uint8List.fromList(utf8.encode(sendData))));
//   expect(kReceiveList.length, expectLen);
// }
//
// String convertMessageString({required name, sender='', data=''}){
//   return SendFile.send(name: name, sender: sender, fileData: Uint8List.fromList(utf8.encode(data))).data;
// }
//
// void callbackActionTest(){
//   group('callback action test', () {
//
//     test('should be not increment list len when receive no command.', () async{
//       await setupCallbackAction();
//       checkReceiveListLen(0, '');
//     });
//
//     test('should be increment list len when receive send file command.', () async{
//       await setupCallbackAction();
//       checkReceiveListLen(1, convertMessageString(name: 'A', data: '!'));
//     });
//
//     test('should be set name to added item.', () async{
//       await setupCallbackAction();
//       checkReceiveListLen(1, convertMessageString(name: 'A', data: '!'));
//       expect(kReceiveList[0].name, 'A');
//     });
//
//     test('should be set sender to added item.', () async{
//       await setupCallbackAction();
//       await checkReceiveListLen(1, convertMessageString(name: 'senderTest', sender: 'sender'));
//       expect(kReceiveList[0].sender, 'sender');
//     });
//
//     test('should be set data to added item.', () async{
//       await setupCallbackAction();
//       await checkReceiveListLen(1, convertMessageString(name: 'dataTest', data: 'test data'));
//       File tempFile = File(p.join((await getTemporaryDirectory()).path, 'dataTest'));
//       String data = await tempFile.readAsString();
//
//       expect(data, 'test data');
//     });
//
//     test('should be add to end item.', () async{
//       await setupCallbackAction();
//       await checkReceiveListLen(1, convertMessageString(name: 'A', data: '!'));
//       await checkReceiveListLen(2, convertMessageString(name: 'B', data: '!'));
//       expect(kReceiveList[0].name, 'A');
//       expect(kReceiveList[1].name, 'B');
//     });
//   });
//
// }

void itemActionTest() {
  // group('delete display by item action test', (){
  //
  //   test('should be able to delete item.', () async{
  //     kReceiveList.append(ReceiveItem(name: 'name', data: Uint8List(0), sender: 'sender'));
  //     kProvider = ReceiveProvider(receiveList: kReceiveList, platform: LocalPlatform());
  //     kProvider.removeAt(0);
  //     expect(kReceiveList.length, 0);
  //   });
  //
  //   test('should be able to delete selected item.', () async{
  //     kReceiveList.append(ReceiveItem(name: 'no target', data: Uint8List(0), sender: 'sender'));
  //     kReceiveList.append(ReceiveItem(name: 'target', data: Uint8List(0), sender: 'sender'));
  //     kReceiveList.append(ReceiveItem(name: 'no target', data: Uint8List(0), sender: 'sender'));
  //     kProvider = ReceiveProvider(receiveList: kReceiveList, platform: LocalPlatform());
  //     kProvider.removeAt(1);
  //     expect(kReceiveList.length, 2);
  //     expect(kReceiveList[0].name, 'no target');
  //     expect(kReceiveList[1].name, 'no target');
  //   });
  //
  // });
}
