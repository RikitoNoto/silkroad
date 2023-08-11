import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camel/camel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:path/path.dart' as p;
import 'package:platform/platform.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:silkroad/option/option_manager.dart';
import 'package:silkroad/send/providers/send_provider.dart';
import 'package:silkroad/send/repository/send_repository.dart';
import 'package:silkroad/send/entities/sendible_device.dart';
import 'package:silkroad/option/params.dart';
import 'package:silkroad/utils/models/animated_list_item_model.dart';
import 'package:silkroad/comm/ipaddress_utility.dart';

import 'send_providers_test.mocks.dart';

late SendProvider kProvider;
late MockFile kFileMock;
late MockSocket kSocketMock;
late Map<String, Object> kParamMap;

Future setParam(String key, Object value) async {
  kParamMap[key] = value;
  SharedPreferences.setMockInitialValues(kParamMap);
  await OptionManager.initialize();
}

@GenerateNiceMocks([MockSpec<SendRepository>()])
@GenerateMocks([Socket])
@GenerateMocks([File])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    kFileMock = MockFile();
    kSocketMock = MockSocket();
    kProvider = SendProvider(
        platform: const LocalPlatform(),
        builder: () => MockSendRepository(),
        sendibleList: AnimatedListItemModel<SendibleDevice>(
          listKey: GlobalKey<AnimatedListState>(),
          removedItemBuilder: (address, index, context, animation) => Text(""),
        ));
    kProvider.file = kFileMock;
    kParamMap = <String, Object>{};
    await setParam(Params.port.toString(), 32099);
    await setParam(Params.name.toString(), '');
  });
  tearDown(() async {
    IpaddressFetcher.ipAddresListSpy = null;
  });
  ipTest();
  fileSetTest();
  sendMessageTest();
  fileNameTest();
  sendibleTest();
}

void fileSetTest() {
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

void fileNameTest() {
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

void setIpAddressToProvider(String ip, {SendProvider? provider}) {
  provider ??= kProvider;
  ip.split('.').asMap().forEach((int i, String octet) {
    provider?.setOctet(i, int.parse(octet));
  });
}

void ipTest() {
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

SendProvider constructProvider({
  Platform? platform,
  SendRepository? repository,
  File? file,
  AnimatedListItemModel<SendibleDevice>? list,
}) {
  SendProvider provider = SendProvider(
      platform: platform ?? const LocalPlatform(),
      builder: () {
        return repository ?? MockSendRepository();
      },
      sendibleList: list ??
          AnimatedListItemModel<SendibleDevice>(
            listKey: GlobalKey<AnimatedListState>(),
            removedItemBuilder: (address, index, context, animation) =>
                Text(""),
          ));
  if (file != null) provider.file = file;
  return provider;
}

void sendMessageTest() {
  MockSendRepository setupConnectAndSend({
    String connectionId = "",
  }) {
    MockSendRepository mockRepo = MockSendRepository();
    // when(mockRepo.connect(any)).thenAnswer((_) => Future.value(connectionId));
    when(mockRepo.send(any, any)).thenAnswer((_) => Future.value(null));
    return mockRepo;
  }

  MockFile createFileMock({
    bool isExist = true,
    String path = "",
    String data = "",
  }) {
    MockFile mockFile = MockFile();
    when(mockFile.exists()).thenAnswer((_) => Future.value(isExist));
    when(mockFile.path).thenAnswer((_) => p.join(path));
    when(mockFile.readAsBytes())
        .thenAnswer((_) => Future.value(Uint8List.fromList(utf8.encode(data))));
    return mockFile;
  }

  group('send test', () {
    test('should be call a send method', () async {
      MockSendRepository mockRepo = MockSendRepository();
      MockFile mockFile = createFileMock();

      SendProvider provider =
          constructProvider(repository: mockRepo, file: mockFile);
      await setParam(Params.port.toString(), 32100);
      setIpAddressToProvider("1.1.1.1", provider: provider);
      SendResult result = await provider.send();

      verify(mockRepo.send("1.1.1.1:32100", any));
      expect(result, SendResult.success);
    });

    checkVerifyNever({
      MockFile? file,
      MockSendRepository? repository,
      required SendResult result,
    }) async {
      MockSendRepository mockRepo = repository ?? MockSendRepository();
      MockFile mockFile = file ?? createFileMock();
      SendProvider provider =
          constructProvider(repository: mockRepo, file: mockFile);
      SendResult result = await provider.send();

      verifyNever(mockRepo.send(any, any));
      expect(result, result);
    }

    test('should be do not call a send method when a file does not set',
        () async {
      MockSendRepository mockRepo = MockSendRepository();
      SendProvider provider = constructProvider(repository: mockRepo);
      SendResult result = await provider.send();

      verifyNever(mockRepo.send(any, any));
      expect(result, SendResult.lostFile);
    });

    test('should be do not call a send method when a file does not exist',
        () async {
      checkVerifyNever(
          file: createFileMock(isExist: false), result: SendResult.lostFile);
    });
  });

  group('close test', () {
    test(
        'should be to call the close method when the send method return a success',
        () async {
      MockSendRepository mockRepo = setupConnectAndSend();
      MockFile mockFile = createFileMock();
      SendProvider provider =
          constructProvider(repository: mockRepo, file: mockFile);
      await provider.send();

      verify(mockRepo.close());
    });

    test(
        'should be to call the close method when the send method throw exception',
        () async {
      MockSendRepository mockRepo = setupConnectAndSend();
      MockFile mockFile = createFileMock();
      SendProvider provider =
          constructProvider(repository: mockRepo, file: mockFile);
      when(mockRepo.send(any, any)).thenAnswer((_) => throw const OSError());
      await provider.send();

      verify(mockRepo.close());
    });
  });

  group('send file test', () {
    test(
        'should be to call the close method when the send method return a success',
        () async {
      MockSendRepository mockRepo = setupConnectAndSend();
      MockFile mockFile = createFileMock(path: "file.file", data: "data");
      SendProvider provider =
          constructProvider(repository: mockRepo, file: mockFile);
      await provider.send();

      verify(mockRepo.send(any, <String, String>{
        "title": "file.file",
        "data": "100,97,116,97",
      }));
    });

    test(
        'should be to call the close method when the send method return a success',
        () async {
      MockSendRepository mockRepo = setupConnectAndSend();
      MockFile mockFile = createFileMock(path: "file.file1", data: "data1");
      SendProvider provider =
          constructProvider(repository: mockRepo, file: mockFile);
      await provider.send();

      verify(mockRepo.send(any, <String, String>{
        "title": "file.file1",
        "data": "100,97,116,97,49",
      }));
    });

    test('should be parse to the base name', () async {
      MockSendRepository mockRepo = setupConnectAndSend();
      MockFile mockFile =
          createFileMock(path: "path/file.file1", data: "data1");
      SendProvider provider =
          constructProvider(repository: mockRepo, file: mockFile);
      await provider.send();

      verify(mockRepo.send(any, <String, String>{
        "title": "file.file1",
        "data": "100,97,116,97,49",
      }));
    });
  });
}

void sendibleTest() {
  group('sendible test', () {
    MockSendRepository createRepositoryMock({
      List<SendibleDevice> ret = const <SendibleDevice>[],
      Function(Invocation invocation)? spyFunc,
    }) {
      MockSendRepository mockRepo = MockSendRepository();

      when(mockRepo.sendible(any, any, any)).thenAnswer((v) {
        spyFunc?.call(v);
        return Future.value(ret);
      });
      return mockRepo;
    }

    Future<
        ({
          AnimatedListItemModel<SendibleDevice> list,
          SendProvider provider
        })> constructProviderWithList({
      SendRepository? repo,
    }) async {
      final list = AnimatedListItemModel<SendibleDevice>(
        listKey: GlobalKey<AnimatedListState>(),
        removedItemBuilder: (address, index, context, animation) => Text(""),
      );
      final provider = constructProvider(
          repository: repo ?? createRepositoryMock(ret: []), list: list);

      await Future.delayed(
          const Duration(milliseconds: 10)); // wait to fetch ip addresses
      return (list: list, provider: provider);
    }

    test('should be 0 length of animated list if return no devices', () async {
      final repoMock = createRepositoryMock(ret: []);
      final provider = await constructProviderWithList(repo: repoMock);
      await provider.provider.searchDevices();
      expect(provider.list.length, 0);
    });

    test('should be 1 length of animated list if return a device', () async {
      const device = SendibleDevice(ipAddress: "192.168.0.1");
      final repoMock = createRepositoryMock(ret: [
        device,
      ]);
      IpaddressFetcher.ipAddresListSpy = ["192.168.0.1"];
      final provider = await constructProviderWithList(repo: repoMock);
      await provider.provider.searchDevices();
      expect(provider.list.length, 1);
      expect(provider.list[0], device);
    });

    test('should be 100 length of animated list if return 100 devices',
        () async {
      final devices = <SendibleDevice>[];
      for (int i = 0; i < 100; i++) {
        devices.add(
          SendibleDevice(ipAddress: "192.168.1.$i"),
        );
      }
      final repoMock = createRepositoryMock(ret: devices);
      IpaddressFetcher.ipAddresListSpy = ["192.168.0.1"];
      final provider = await constructProviderWithList(repo: repoMock);
      await provider.provider.searchDevices();
      expect(provider.list.length, 100);
      for (int i = 0; i < 100; i++) {
        expect(provider.list[i].ipAddress, "192.168.1.$i");
      }
    });

    test('should pass the ipaddress itself', () async {
      final repoMock = createRepositoryMock(
          ret: [],
          spyFunc: (invocation) {
            final connectionPoint = invocation.positionalArguments[2] as String;
            expect(connectionPoint, "192.168.0.1:32099");
          });

      await setParam(Params.port.toString(), 32099);
      IpaddressFetcher.ipAddresListSpy = ["192.168.0.1"];
      final provider = await constructProviderWithList(repo: repoMock);
      await provider.provider.searchDevices();
      verify(repoMock.sendible(any, any, any));
    });

    test('should pass the network address itself', () async {
      final repoMock = createRepositoryMock(
          ret: [],
          spyFunc: (invocation) {
            final networkAddress = invocation.positionalArguments[0] as String;
            expect(networkAddress, "192.168.0");
          });

      IpaddressFetcher.ipAddresListSpy = ["192.168.0.1"];
      final provider = await constructProviderWithList(repo: repoMock);
      await provider.provider.searchDevices();
      verify(repoMock.sendible(any, any, any));
    });

    test('should pass the send port that is same of itself', () async {
      final repoMock = createRepositoryMock(
          ret: [],
          spyFunc: (invocation) {
            final port = invocation.positionalArguments[1] as int;
            expect(port, 32099);
          });

      IpaddressFetcher.ipAddresListSpy = ["192.168.0.1"];
      final provider = await constructProviderWithList(repo: repoMock);
      await provider.provider.searchDevices();
      verify(repoMock.sendible(any, any, any));
    });

    test('should call sendible method twice if it has two addresses', () async {
      final subnetList = ["192.168.0", "192.168.1"];
      final portList = [32099, 32099];
      final connectionPointList = ["192.168.0.1:32099", "192.168.1.1:32099"];
      final repoMock = createRepositoryMock(
          ret: [],
          spyFunc: (invocation) {
            final networkAddress = invocation.positionalArguments[0] as String;
            final port = invocation.positionalArguments[1] as int;
            final connectionPoint = invocation.positionalArguments[2] as String;

            expect(networkAddress, subnetList[0]);
            expect(port, portList[0]);
            expect(connectionPoint, connectionPointList[0]);

            subnetList.removeAt(0);
            portList.removeAt(0);
            connectionPointList.removeAt(0);
          });

      IpaddressFetcher.ipAddresListSpy = ["192.168.0.1", "192.168.1.1"];
      final provider = await constructProviderWithList(repo: repoMock);
      await provider.provider.searchDevices();
      expect(verify(repoMock.sendible(any, any, any)).callCount, 2);
    });

    test('should not call same network addresses', () async {
      final repoMock = createRepositoryMock(
        ret: [],
      );

      IpaddressFetcher.ipAddresListSpy = ["192.168.0.1", "192.168.0.2"];
      final provider = await constructProviderWithList(repo: repoMock);
      await provider.provider.searchDevices();
      expect(verify(repoMock.sendible(any, any, any)).callCount, 1);
    });
  });
}
