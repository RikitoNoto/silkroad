// 受信画面
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'receive_list_item.dart';

// 受信画面描画クラス
class ReceivePage extends StatefulWidget {
  const ReceivePage({super.key});

  @override
  State<ReceivePage> createState() => _ReceivePageState();
}

class _DebugListModel<E> {
  _DebugListModel({
    required this.listKey,
  });

  final GlobalKey<AnimatedListState> listKey;
  final List<E> _items = <E>[];

  AnimatedListState? get _animatedList => listKey.currentState;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList!.insertItem(index);
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}

class _debugListItemStruct{
  const _debugListItemStruct({
    required this.iconData,
    required this.name,
    required this.size,
    required this.sender,
  });
  final IconData iconData;
  final String name;
  final int size;
  final String sender;
}

class _ReceivePageState extends State<ReceivePage>{
  final _listKey = GlobalKey<AnimatedListState>();
  late _DebugListModel<_debugListItemStruct> _debugList;
  final List<_debugListItemStruct> _debugItems = [
    const _debugListItemStruct(iconData: Icons.system_update, name: "system", size: 310, sender: "update"),
    const _debugListItemStruct(iconData: Icons.add_moderator, name: "moderator", size: 000, sender: "adder"),
    const _debugListItemStruct(iconData: Icons.add_task, name: "task", size: 679, sender: "adder"),
    const _debugListItemStruct(iconData: Icons.wifi_tethering_error_outlined, name: "error", size: 7, sender: "buglover"),
    const _debugListItemStruct(iconData: Icons.volume_mute_sharp, name: "volume", size: 1000, sender: "pin"),
    const _debugListItemStruct(iconData: Icons.video_stable, name: "video", size: 6797, sender: "ummm"),
    const _debugListItemStruct(iconData: Icons.turn_sharp_right, name: "turn", size: 657109, sender: "right"),
    const _debugListItemStruct(iconData: Icons.timer_10, name: "timer", size: 159465, sender: "cool"),
  ];
  int _debugItemIndex = 0;


  @override
  void initState() {
    super.initState();
    _debugList = _DebugListModel<_debugListItemStruct>(
      listKey: _listKey,
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
    List<Widget> debug_actions = [];
    if(kDebugMode){
      debug_actions.add(
        IconButton(
          icon: const Icon(Icons.add_circle),
          onPressed: _debugInsertItem,
        )
      );

      debug_actions.add(
        IconButton(
            icon: const Icon(Icons.remove_circle),
            onPressed: _debugRemoveItem,
        ),
      );
    }

    return debug_actions;
  }


  void _debugInsertItem()
  {
    _debugList.insert(0, _debugItems[_debugList.length%_debugItems.length]);
    _debugItemIndex++;
  }

  void _debugRemoveItem()
  {

  }

  Widget _buildItem(BuildContext context, int index, Animation<double> animation)
  {
    // int _index = _debugList.length%_debugItems.length;
    return ReceiveListItem(
      iconData: _debugList[index].iconData,
      name: _debugList[index].name,
      size: _debugList[index].size,
      sender: _debugList[index].sender,
      animation: animation
    );
  }

  Widget _buildBody(BuildContext context)
  {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            // 入力欄
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: <Widget>[
                  // パスワード入力欄
                  const Expanded(
                    child: TextField(
                      maxLines: 1,
                    ),
                  ),

                  const SizedBox(
                    width: 30,
                  ),

                  // ポート解放ボタン
                  ElevatedButton(
                    onPressed: ()=>{},
                    child: const Text("OPEN")
                  ),
                ],
              ),
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
      )
    );
  }
}

