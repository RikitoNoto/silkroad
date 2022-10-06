import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:platform/platform.dart';

import 'package:silkroad/utils/views/alternate_action_button.dart';
import 'package:silkroad/utils/views/animated_list_item_model.dart';
import 'package:silkroad/app_theme.dart';
import 'receive_list_item.dart';
import '../receive_item_info.dart';

class ReceivePage extends StatefulWidget {
  const ReceivePage({
    super.key,
    required this.platform,
  });

  final Platform platform;

  @override
  State<ReceivePage> createState() => _ReceivePageState();
}

class _ReceivePageState extends State<ReceivePage>{
  final _listKey = GlobalKey<AnimatedListState>();
  late AnimatedListItemModel<ReceiveItemInfo> _receiveList;
  List<String> _addressList = <String>['192.168.12.1', '192.168.12.2'];

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
      index: index,
      iconData: _receiveList[index].iconData,
      name: _receiveList[index].name,
      size: _receiveList[index].size,
      sender: _receiveList[index].sender,
      animation: animation,
    );
  }

  Widget _removeItem(ReceiveItemInfo item, int index, BuildContext context, Animation<double> animation)
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
                child: _buildIpDisplay(context),
              ),
            ),

            AlternateActionButton(
              startIcon: Icons.play_arrow,
              endIcon: Icons.pause,
              progressIndicatorColor: Colors.blue,
              iconColor: AppTheme.getForegroundColor(context),
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

  Widget _buildIpDisplay(BuildContext context){
    Widget ipDisplay;
    switch(widget.platform.operatingSystem){
      case Platform.iOS:
        ipDisplay = _buildIpListForIos(context);
        break;
      default:
        ipDisplay = _buildIpListForAndroidPc(context);
        break;
    }

    return ipDisplay;
  }

  Widget _buildIpListForAndroidPc(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.getSecondaryBackgroundColor(context)),
        borderRadius: BorderRadius.circular(5),

      ),
      child: DropdownButton(
        value: _addressList.isNotEmpty ? _addressList[0] : '',
        icon: const Icon(Icons.arrow_drop_down),
        iconSize: 30,
        isExpanded: true,
        underline: DropdownButtonHideUnderline(child: Container()),
        elevation: 0,
        onChanged: (text) => {},
        items: _addressList.map((address) => DropdownMenuItem(child: Text(address), value: address,)).toList(),
      ),
    );
  }

  Widget _buildIpListForIos(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.getSecondaryBackgroundColor(context)),
        borderRadius: BorderRadius.circular(5),

      ),
      child:CupertinoButton(
        child: Stack(
          children: [
            Text('ip address'),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.arrow_drop_down,
                color: AppTheme.getForegroundColor(context),
                // color: Colors.black,
              )
            ),
          ],
        ),
        onPressed: (){
          _showModalPicker(context);
        },
      ),
    );
  }

  void _showModalPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CupertinoPicker(
              itemExtent: 40,
              children: <Widget>[
                Text('A'),
                Text('A'),
                Text('A'),
                Text('A'),
                Text('A'),
                Text('A'),
              ],
              onSelectedItemChanged: (value) {

              },
            ),
          ),
        );
      },
    );
  }

}

