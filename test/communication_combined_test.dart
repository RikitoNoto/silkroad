import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:platform/platform.dart';
import 'package:path/path.dart' as p;

import 'package:silkroad/send/providers/send_provider.dart';
import 'package:silkroad/receive/providers/receive_provider.dart';
import 'package:silkroad/receive/repository/receive_item.dart';
import 'package:silkroad/utils/models/animated_list_item_model.dart';

import 'spy/path_provider_spy.dart';
import 'communication_combined_test.mocks.dart';

late MockSocket kSocketMock;
late SendProvider kSendProvider;
late ReceiveProvider kReceiveProvider;
late AnimatedListItemModel<ReceiveItem> kReceiveList;
late GlobalKey<AnimatedListState> kGlobalKey;

String? kSendData;

Widget _removeItemBuilderSpy(ReceiveItem item, int index, BuildContext context, Animation<double> animation){
  return Text('');
}

@GenerateMocks([Socket])
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Directory spyRootDir = Directory(p.join('test','temp'));
  Directory tempDir = Directory(p.join(spyRootDir.path, 'temp'));
  setUpAll((){
    PathProviderPlatformSpy.temporaryPath = tempDir.path;
  });

  setUp(() async{
    await pathProviderSetUp();

    kGlobalKey = GlobalKey<AnimatedListState>();
    kReceiveList = AnimatedListItemModel<ReceiveItem>(
      listKey: kGlobalKey,
      removedItemBuilder: _removeItemBuilderSpy,
    );
    kSendProvider = SendProvider();
    kReceiveProvider = ReceiveProvider(platform: LocalPlatform(), receiveList: kReceiveList);

    kSocketMock = MockSocket();
  });

  tearDown(() async{
    kReceiveProvider.close();
    await pathProviderTearDown();
  });

  checkSendAndReceive();
}

void checkSendAndReceive(){
  group('send and receive test', () {
    test('should be send and receive message', () async{
      kReceiveProvider.overwriteAddressList(['127.0.0.1']);
      kReceiveProvider.selectIp('127.0.0.1');
      kReceiveProvider.open();

      await Future.delayed(Duration(milliseconds: 1));

      kSendProvider.setOctet(0, 127);
      kSendProvider.setOctet(1, 0);
      kSendProvider.setOctet(2, 0);
      kSendProvider.setOctet(3, 1);

      List<int> expectData = [0x00, 0x01];
      Directory dir = Directory(p.join((await getTemporaryDirectory()).path, 'send'));
      await dir.create(recursive: true);
      File file = File(p.join((await getTemporaryDirectory()).path, 'send_file'));
      await file.writeAsBytes(expectData, mode: FileMode.writeOnlyAppend);
      kSendProvider.file = file;
      await kSendProvider.send();

      await Future.delayed(Duration(milliseconds: 10));


      expect(kReceiveList.length, 1);
      File receiveFile = File(kReceiveList[0].tempPath);
      expect(await receiveFile.exists(), isTrue);
      Uint8List fileData = await receiveFile.readAsBytes();
      for(int i=0; i < expectData.length; i++){
        expect(fileData[i], expectData[i]);
      }
    });

  });
}
