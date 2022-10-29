import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:platform/platform.dart';
import 'package:path/path.dart' as p;

import 'package:silkroad/option/option_manager.dart';
import 'package:silkroad/send/providers/send_provider.dart';
import 'package:silkroad/receive/providers/receive_provider.dart';
import 'package:silkroad/receive/repository/receive_item.dart';
import 'package:silkroad/utils/models/animated_list_item_model.dart';
import 'package:silkroad/comm/message.dart';

import 'spy/path_provider_spy.dart';

late SendProvider kSendProvider;
late ReceiveProvider kReceiveProvider;
late AnimatedListItemModel<ReceiveItem> kReceiveList;
late GlobalKey<AnimatedListState> kGlobalKey;


Widget _removeItemBuilderSpy(ReceiveItem item, int index, BuildContext context, Animation<double> animation){
  return Text('');
}

Future _setUp() async{
  await pathProviderSetUp();

  kGlobalKey = GlobalKey<AnimatedListState>();
  kReceiveList = AnimatedListItemModel<ReceiveItem>(
    listKey: kGlobalKey,
    removedItemBuilder: _removeItemBuilderSpy,
  );
  kSendProvider = SendProvider();
  kReceiveProvider = ReceiveProvider(platform: LocalPlatform(), receiveList: kReceiveList);
}

Future _tearDown() async{
  kReceiveProvider.close();
  await pathProviderTearDown();
}

Future _dummyTest() async{
  await _setUp();

  await openPort();

  await sendData([0x00]);

  await Future.delayed(Duration(milliseconds: 200));

  await _tearDown();
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Directory spyRootDir = Directory(p.join('test','temp'));
  Directory tempDir = Directory(p.join(spyRootDir.path, 'temp'));
  setUpAll(() async{
    PathProviderPlatformSpy.temporaryPath = tempDir.path;
    OptionManager.initialize();
    await _dummyTest(); //FIXME: why this dummy test? if this test is not run, fail a test of [sendAndReceiveTest] in code magic.
  });

  setUp(() async{
    await _setUp();
  });

  tearDown(() async{
    await _tearDown();
  });

  sendAndReceiveTest();
}

Future openPort() async{
  kReceiveProvider.overwriteAddressList(['127.0.0.1']);
  kReceiveProvider.selectIp('127.0.0.1');
  kReceiveProvider.open();

  await Future.delayed(Duration(milliseconds: 1));
}

Future sendData(List<int> expectData) async{

  kSendProvider.setOctet(0, 127);
  kSendProvider.setOctet(1, 0);
  kSendProvider.setOctet(2, 0);
  kSendProvider.setOctet(3, 1);

  Directory dir = Directory(p.join((await getTemporaryDirectory()).path, 'send'));
  await dir.create(recursive: true);
  File file = File(p.join((await getTemporaryDirectory()).path, 'send_file'));
  await file.writeAsBytes(expectData, mode: FileMode.writeOnlyAppend);
  kSendProvider.file = file;
  await kSendProvider.send();
}

Future checkSendAndReceive(List<int> expectData, {int waitTimeMs=10}) async{

  await openPort();

  await sendData(expectData);

  if(waitTimeMs < 1000){
    await Future.delayed(Duration(milliseconds: waitTimeMs));
  }
  else{
    for(int i=1; i<=waitTimeMs; i++){
      if( (kReceiveList.length > 0) &&
          (await File(kReceiveList[0].tempPath).exists())){
        break;
      }
      await Future.delayed(Duration(milliseconds: 1));
    }
  }

  expect(kReceiveList.length, 1);
  File receiveFile = File(kReceiveList[0].tempPath);
  expect(await receiveFile.exists(), isTrue);
  Uint8List fileData = await receiveFile.readAsBytes();
  for(int i=0; i < expectData.length; i++){
    expect(fileData[i], expectData[i]);
  }
}

void sendAndReceiveTest(){
  group('send and receive test', () {

    test('should be send and receive message', () async{
      await checkSendAndReceive(<int>[0x00, 0x01]);
    });

    test('should be send and receive message 1024byte', () async{
      List<int> expectData = [];
      for(int i=0; i<1024; i++){
        expectData.add(0x00);
      }
      await checkSendAndReceive(expectData);
    });

    test('should be send and receive message 1024kbyte', () async{
      List<int> expectData = [];
      for(int i=0; i<1024*1024; i++){
        expectData.add(0x00);
      }
      await checkSendAndReceive(expectData, waitTimeMs: 5000);
    });

    test('should be send and receive message 65536', () async{
      List<int> expectData = [];
      int headerSize = Uint8List.fromList(utf8.encode(SendFile.send(name: 'name', sender: '', fileData: Uint8List(0)).data)).length;

      for(int i=0; i<65536 - headerSize - 5; i++){
        expectData.add(0x00);
      }

      await checkSendAndReceive(expectData, waitTimeMs: 50);
    });
  });
}
