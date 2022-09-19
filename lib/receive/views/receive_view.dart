// 受信画面
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:silkroad/utils/views/alternate_action_button.dart';
import 'package:silkroad/utils/views/password_action_field.dart';
import 'package:silkroad/utils/views/animated_list_item_model.dart';
import 'receive_list_item.dart';
import '../receive_item_info.dart';

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
      home: const ReceivePage(),
    );
  }
}

// 受信画面描画クラス
class ReceivePage extends StatefulWidget {
  const ReceivePage({super.key});

  @override
  State<ReceivePage> createState() => _ReceivePageState();
}

class _ReceivePageState extends State<ReceivePage>{
  final _listKey = GlobalKey<AnimatedListState>();
  late AnimatedListItemModel<ReceiveItemInfo> _receiveList;

  final List<ReceiveItemInfo> _debugReceiveItems = [
    const ReceiveItemInfo(iconData: Icons.system_update, name: "system", size: 310, sender: "update"),
    const ReceiveItemInfo(iconData: Icons.add_moderator, name: "moderator", size: 000, sender: "adder"),
    const ReceiveItemInfo(iconData: Icons.add_task, name: "task", size: 679, sender: "adder"),
    const ReceiveItemInfo(iconData: Icons.wifi_tethering_error_outlined, name: "error", size: 7, sender: "buglover"),
    const ReceiveItemInfo(iconData: Icons.volume_mute_sharp, name: "volume", size: 1000, sender: "pin"),
    const ReceiveItemInfo(iconData: Icons.video_stable, name: "video", size: 6797, sender: "ummm"),
    const ReceiveItemInfo(iconData: Icons.turn_sharp_right, name: "turn", size: 657109, sender: "right"),
    const ReceiveItemInfo(iconData: Icons.timer_10, name: "timer", size: 159465, sender: "cool"),
  ];

  @override
  void initState() {
    super.initState();
    _receiveList = AnimatedListItemModel<ReceiveItemInfo>(
      listKey: _listKey,
      removedItemBuilder: _removeItem,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receive"),
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
    _receiveList.insert(_receiveList.length, _debugReceiveItems[_receiveList.length%_debugReceiveItems.length]);
  }

  void _debugRemoveItem()
  {
    if(_receiveList.length > 0){
      setState(() {
        _receiveList.removeAt(0);
      });
    }
  }

  Widget _buildItem(BuildContext context, int index, Animation<double> animation)
  {
    return ReceiveListItem(
      iconData: _receiveList[index].iconData,
      name: _receiveList[index].name,
      size: _receiveList[index].size,
      sender: _receiveList[index].sender,
      animation: animation,
    );
  }

  Widget _removeItem(ReceiveItemInfo item, BuildContext context, Animation<double> animation)
  {
    return ReceiveListItemRemoving(
        iconData: item.iconData,
        name: item.name,
        size: item.size,
        sender: item.sender,
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
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.language),
                      labelText: "Ipaddress",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Expanded(
                      child: Text(
                        "0.0.0.0",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              AlternateActionButton(
                startIcon: Icons.play_arrow,
                endIcon: Icons.pause,
              ),
            ],
          ),
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
}

