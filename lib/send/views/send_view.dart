// 送信画面
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:silkroad/utils/views/password_action_field.dart';
import 'package:silkroad/utils/views/animated_list_item_model.dart';
import '../send_item_info.dart';
import 'send_list_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SendPage(),
    );
  }
}

// 送信画面描画クラス
class SendPage extends StatefulWidget {
  const SendPage({super.key});

  @override
  State<SendPage> createState() => _SendPageState();
}

class _SendPageState extends State<SendPage>{
  final _listKey = GlobalKey<AnimatedListState>();
  late AnimatedListItemModel<SendItemInfo> _sendList;
  String _selectFile = "No select";

  final List<SendItemInfo> _debugSendItems = [
    const SendItemInfo(deviceName: "system", receiver: "update"),
    const SendItemInfo(deviceName: "moderator", receiver: "adder"),
    const SendItemInfo(deviceName: "task", receiver: "adder"),
    const SendItemInfo(deviceName: "error", receiver: "buglover"),
    const SendItemInfo(deviceName: "volume", receiver: "pin"),
    const SendItemInfo(deviceName: "video", receiver: "ummm"),
    const SendItemInfo(deviceName: "turn", receiver: "right"),
    const SendItemInfo(deviceName: "timer", receiver: "cool"),
  ];

  @override
  void initState() {
    super.initState();
    _sendList = AnimatedListItemModel<SendItemInfo>(
      listKey: _listKey,
      removedItemBuilder: _removeItem,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Send"),
          actions: _getDebugActions(),
        ),

        body: _buildBody(context)
    );
  }

  List<Widget> _getDebugActions()
  {
    List<Widget> debugActions = [];
    if(kDebugMode){
      debugActions.add(
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: _debugInsertItem,
          )
      );

      debugActions.add(
        IconButton(
          icon: const Icon(Icons.remove_circle),
          onPressed: _debugRemoveItem,
        ),
      );
    }

    return debugActions;
  }


  void _debugInsertItem()
  {
    _sendList.insert(_sendList.length, _debugSendItems[_sendList.length%_debugSendItems.length]);
  }

  void _debugRemoveItem()
  {
    if(_sendList.length > 0){
      setState(() {
        _sendList.removeAt(0);
      });
    }
  }

  Widget _buildItem(BuildContext context, int index, Animation<double> animation)
  {
    return SendListItem(
      deviceName: _sendList[index].deviceName,
      receiver: _sendList[index].receiver,
      animation: animation,
    );
  }

  Widget _removeItem(SendItemInfo item, BuildContext context, Animation<double> animation)
  {
    return SendListItemRemoving(
        deviceName: item.deviceName,
        receiver: item.receiver,
        animation: animation
    );
  }

  Widget _buildBody(BuildContext context)
  {
    return Container(
        color: Colors.white,
        child: Column(
            children: [
              // 入力欄
              // const PasswordActionField(
              //   startIcon: Icons.play_arrow,
              //   endIcon: Icons.pause,
              // ),
              _buildIpField(context),
              _buildFileSelector(),

              // 受信リスト
              Flexible(
                child: AnimatedList(
                  key: _listKey,
                  itemBuilder: _buildItem,
                ),
              ),
            ]
        )
    );
  }

  Widget _buildIpField(BuildContext context)
  {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            // パスワード入力欄
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                labelText: "Ipaddress",
                ),
                maxLines: 1,
                // enabled: _enableField,
              ),
            ),


          ],
        ),
      ),
    );
  }

  Widget _buildFileSelector()
  {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 10),
            decoration: const BoxDecoration(
            ),
            child: Text(
              _selectFile,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ElevatedButton.icon(
            label: const Text("select file"),
            icon: const Icon(Icons.search),
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();
              if (result != null) {
                File file = File(result.files.single.path!);
                setState(() {
                  _selectFile = basename(file.path);
                });
              }
            },
          ),
        ),
      ],
    );
  }
}

