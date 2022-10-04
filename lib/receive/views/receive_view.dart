import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:silkroad/utils/views/alternate_action_button.dart';
import 'package:silkroad/utils/models/animated_list_item_model.dart';
import 'package:silkroad/app_theme.dart';
import 'receive_list_item.dart';
import '../repository/receive_item.dart';

class ReceivePage extends StatefulWidget {
  const ReceivePage({super.key});

  @override
  State<ReceivePage> createState() => _ReceivePageState();
}

class _ReceivePageState extends State<ReceivePage>{
  final _listKey = GlobalKey<AnimatedListState>();
  late AnimatedListItemModel<ReceiveItem> _receiveList;

  final List<ReceiveItem> _debugReceiveItems = [
    ReceiveItem(iconData: Icons.system_update, name: "system", data: Uint8List(0), sender: "update"),
    ReceiveItem(iconData: Icons.add_moderator, name: "moderator", data: Uint8List(0), sender: "adder"),
    ReceiveItem(iconData: Icons.add_task, name: "task", data: Uint8List(0), sender: "adder"),
    ReceiveItem(iconData: Icons.wifi_tethering_error_outlined, name: "error", data: Uint8List(0), sender: "buglover"),
    ReceiveItem(iconData: Icons.volume_mute_sharp, name: "volume", data: Uint8List(0), sender: "pin"),
    ReceiveItem(iconData: Icons.video_stable, name: "video", data: Uint8List(0), sender: "ummm"),
    ReceiveItem(iconData: Icons.turn_sharp_right, name: "turn", data: Uint8List(0), sender: "right"),
    ReceiveItem(iconData: Icons.timer_10, name: "timer", data: Uint8List(0), sender: "cool"),
  ];


  @override
  void initState() {
    super.initState();
    _receiveList = AnimatedListItemModel<ReceiveItem>(
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
      index: index,
      iconData: _receiveList[index].iconData,
      name: _receiveList[index].name,
      size: _receiveList[index].size,
      sender: _receiveList[index].sender,
      animation: animation,
    );
  }

  Widget _removeItem(ReceiveItem item, int index, BuildContext context, Animation<double> animation)
  {
    return ReceiveListItemRemoving(
      index: index,
      iconData: item.iconData,
      name: item.name,
      size: item.size,
      sender: item.sender,
      animation: animation
    );
  }

  Widget _buildBody(BuildContext context)
  {
    return Column(
      children: [
        // input field
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: InputDecorator(
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: const Icon(Icons.language),
                    labelText: "My Ipaddress",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    "0.0.0.0",
                    style: TextStyle(
                      // color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),

            AlternateActionButton(
              startIcon: Icons.play_arrow,
              endIcon: Icons.pause,
              progressIndicatorColor: Colors.blue,
              iconColor: MediaQuery.platformBrightnessOf(context) == Brightness.dark ? Colors.white : Colors.black,
            ),
          ],
        ),

        // receive list
        Flexible(
          child: Container(
            color: AppTheme.getSecondaryBackgroundColor(context),
            child: AnimatedList(
              key: _listKey,
              itemBuilder: _buildItem,
            ),
          ),
        ),
      ]
    );
  }
}

