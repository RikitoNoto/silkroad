import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:platform/platform.dart';

import 'package:silkroad/utils/views/alternate_action_button.dart';
import 'package:silkroad/utils/models/animated_list_item_model.dart';
import 'package:silkroad/app_theme.dart';
import 'receive_list_item.dart';
import 'package:silkroad/receive/repository/receive_item.dart';
import 'package:silkroad/receive/providers/receive_provider.dart';

class ReceivePage extends StatefulWidget {
  const ReceivePage({
    super.key,
    required this.platform,
  });

  final Platform platform;

  @override
  State<ReceivePage> createState() => ReceivePageState();
}

class ReceivePageState extends State<ReceivePage>{
  final _listKey = GlobalKey<AnimatedListState>();
  late AnimatedListItemModel<ReceiveItem> _receiveList;
   late ReceiveProvider _provider;
  List<String> _addressList = <String>['192.168.12.1', '192.168.12.2'];

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
    _provider = ReceiveProvider(receiveList: _receiveList);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _provider,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Receive"),
          actions: _getDebugActions(),
        ),

        body: _buildBody(context)
      ),
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
                child: _buildIpDisplay(context),
              ),
            ),

            AlternateActionButton(
              startIcon: Icons.play_arrow,
              endIcon: Icons.pause,
              progressIndicatorColor: Colors.blue,
              iconColor: AppTheme.getForegroundColor(context),
              onTap: (state){
                if(state == AlternateActionStatus.active){
                  _provider.open('');
                }
                else{
                  _provider.close();
                }
              },
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

