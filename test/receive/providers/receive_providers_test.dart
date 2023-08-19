import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:platform/platform.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silkroad/receive/providers/providers.dart';

import 'receive_providers_test.mocks.dart';

import 'package:silkroad/receive/repository/receive_repository.dart';
import 'package:silkroad/utils/models/animated_list_item_model.dart';
import 'package:silkroad/receive/entity/receive_item.dart';
import 'package:silkroad/parameter.dart';
import '../../spy/path_provider_spy.dart';

Future setPort(int port) async {
  SharedPreferences.setMockInitialValues(
      <String, Object>{Params.port.toString(): port});
  await OptionManager.initialize();
}

@GenerateMocks([ReceiveRepository])
@GenerateMocks([ReceiveItem])
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    PathProviderPlatformSpy.temporaryPath = kTempDir.path;
  });

  setUp(() async {
    await pathProviderSetUp();
  });

  tearDown(() async {
    await pathProviderTearDown();
  });

  afterReceiveTest();
  ipAddressTest();
  itemActionTest();
  portTest();
}

void ipAddressTest() {
  group('ip address test', () {
    test('should be not set ip address when the ip list is empty', () {
      ReceiveProvider provider = constructProvider();
      provider.overwriteAddressList(<String>[]);
      provider.selectIp('192.168.1.100');
      expect(provider.currentIp, '');
    });

    test('should be set ip address when the ip is include in the ip list', () {
      ReceiveProvider provider = constructProvider();
      provider.overwriteAddressList(<String>['192.168.1.100']);
      provider.selectIp('192.168.1.100');
      expect(provider.currentIp, '192.168.1.100');
    });

    test(
        'should be return false when the ip is not include in the ip list(empty)',
        () {
      ReceiveProvider provider = constructProvider();
      provider.overwriteAddressList(<String>[]);
      expect(provider.isEnableIp('192.168.1.100'), isFalse);
    });

    test('should be return true when the ip is include in the ip list', () {
      ReceiveProvider provider = constructProvider();
      provider.overwriteAddressList(<String>['192.168.1.100']);
      expect(provider.isEnableIp('192.168.1.100'), isTrue);
    });
  });
}

Future checkOpenPort(
  MockReceiveRepository repo,
  ReceiveProvider provider,
  String ip,
  int port,
  List<ReceiveItem> receiveSpy, {
  StreamController<ReceiveItem>? streamController,
}) async {
  streamController ??= StreamController<ReceiveItem>();

  // construct listen mock.
  when(repo.listen(any)).thenAnswer((_) {
    for (ReceiveItem item in receiveSpy) {
      streamController!.sink.add(item);
    }
    return streamController!.stream;
  });

  // set ip address
  provider.overwriteAddressList([ip]);
  provider.selectIp(ip);
  await setPort(port);

  await provider.open();

  verify(repo.listen('$ip:$port'));
}

ReceiveProvider constructProvider({
  AnimatedListItemModel? receiveList,
  Platform? platform,
  ReceiveRepository? repository,
}) {
  return ReceiveProvider(
    receiveList: receiveList ?? constructListItem([]),
    platform: platform ?? const LocalPlatform(),
    builder: () {
      return repository ?? MockReceiveRepository();
    },
  );
}

AnimatedListItemModel<ReceiveItem> constructListItem(List<ReceiveItem> items) {
  AnimatedListItemModel<ReceiveItem> itemList =
      AnimatedListItemModel<ReceiveItem>(
    listKey: GlobalKey<AnimatedListState>(),
    removedItemBuilder: (ReceiveItem item, int index, BuildContext context,
            Animation<double> animation) =>
        const Text(''),
  );

  for (ReceiveItem item in items) {
    itemList.append(item);
  }
  return itemList;
}

void portTest() {
  group('port open and close test', () {
    test('should be open port when call the open method', () async {
      MockReceiveRepository mockRepo = MockReceiveRepository();
      ReceiveProvider provider = constructProvider(repository: mockRepo);
      checkOpenPort(mockRepo, provider, "192.168.1.1", 32099, []);
    });

    test('should be open port when call the open method [1000]', () async {
      await setPort(1000);
      MockReceiveRepository mockRepo = MockReceiveRepository();
      ReceiveProvider provider = constructProvider(repository: mockRepo);
      checkOpenPort(mockRepo, provider, "192.168.1.1", 1000, []);
    });

    test('should be open port when parameter is null', () async {
      (await SharedPreferences.getInstance()).remove(Params.port.toString());
      MockReceiveRepository mockRepo = MockReceiveRepository();
      ReceiveProvider provider = constructProvider(repository: mockRepo);
      checkOpenPort(mockRepo, provider, "192.168.1.1", 32099, []);
    });

    test('should be close port when call the close method', () async {
      MockReceiveRepository mockRepo = MockReceiveRepository();
      ReceiveProvider provider = constructProvider(repository: mockRepo);
      when(mockRepo.close());
      provider.close();
      verify(mockRepo.close()); // should be call the repository.close.
    });
  });
}

Future<AnimatedListItemModel<ReceiveItem>> setupAfterReceiveTest(
    List<ReceiveItem> receiveItems) async {
  MockReceiveRepository mockRepo = MockReceiveRepository();
  StreamController<ReceiveItem> streamController =
      StreamController<ReceiveItem>();
  AnimatedListItemModel<ReceiveItem> itemList = constructListItem([]);
  ReceiveProvider provider =
      constructProvider(repository: mockRepo, receiveList: itemList);
  checkOpenPort(
    mockRepo,
    provider,
    "127.0.0.1",
    32099,
    receiveItems,
    streamController: streamController,
  );
  await Future.delayed(const Duration(milliseconds: 10));
  streamController.close();

  return itemList;
}

void afterReceiveTest() {
  group('after receive data test', () {
    test('should be increase item list after received item.', () async {
      MockReceiveItem itemMock1 = MockReceiveItem();
      MockReceiveItem itemMock2 = MockReceiveItem();
      AnimatedListItemModel<ReceiveItem> itemList =
          await setupAfterReceiveTest([
        itemMock1,
        itemMock2,
      ]);

      expect(itemList.length, 2);
      expect(itemList[0], itemMock1);
      expect(itemList[1], itemMock2);
    });
  });
}

void itemActionTest() {
  group('delete display by item action test', () {
    test('should be able to delete item.', () async {
      AnimatedListItemModel<ReceiveItem> itemList = constructListItem([
        ReceiveItem(name: 'name', data: Uint8List(0), sender: 'sender'),
      ]);
      ReceiveProvider provider = constructProvider(receiveList: itemList);
      provider.removeAt(0);
      expect(itemList.length, 0);
    });

    test('should be able to delete selected item.', () async {
      AnimatedListItemModel<ReceiveItem> itemList = constructListItem([
        ReceiveItem(name: 'no target', data: Uint8List(0), sender: 'sender'),
        ReceiveItem(name: 'target', data: Uint8List(0), sender: 'sender'),
        ReceiveItem(name: 'no target', data: Uint8List(0), sender: 'sender'),
      ]);
      ReceiveProvider provider = constructProvider(receiveList: itemList);
      provider.removeAt(1);
      expect(itemList.length, 2);
      expect(itemList[0].name, 'no target');
      expect(itemList[1].name, 'no target');
    });
  });
}
