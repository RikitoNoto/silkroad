// 受信画面
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:silkroad/receive/views/AnimatedPlayPauseButton.dart';
import 'receive_list_item.dart';
import '../receive_item_info.dart';

// 受信画面描画クラス
class ReceivePage extends StatefulWidget {
  const ReceivePage({super.key});

  @override
  State<ReceivePage> createState() => _ReceivePageState();
}

typedef _RemovedItemBuilder<T> = Widget Function(
    T item, BuildContext context, Animation<double> animation);

class _ReceiveListModel<E> {
  _ReceiveListModel({
    required this.listKey,
    required this.removedItemBuilder,
  });

  final GlobalKey<AnimatedListState> listKey;
  final List<E> _items = <E>[];
  final _RemovedItemBuilder<E> removedItemBuilder;

  AnimatedListState? get _animatedList => listKey.currentState;
  static const _durationDefault = Duration(milliseconds: 1000);

  void insert(int index, E item, {Duration duration = _durationDefault}) {
    _items.insert(index, item);
    _animatedList!.insertItem(index, duration: duration);
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList!.removeItem(
        index,
            (BuildContext context, Animation<double> animation) {
          return removedItemBuilder(removedItem, context, animation);
        },
      );
    }
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}

class _ReceivePageState extends State<ReceivePage>{
  final _listKey = GlobalKey<AnimatedListState>();
  late _ReceiveListModel<ReceiveItemInfo> _receiveList;
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
  int _debugItemIndex = 0;


  @override
  void initState() {
    super.initState();
    _receiveList = _ReceiveListModel<ReceiveItemInfo>(
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
    _receiveList.insert(_receiveList.length, _debugReceiveItems[_receiveList.length%_debugReceiveItems.length]);
    _debugItemIndex++;
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
                  const AnimatedPlayPauseButton(),
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

