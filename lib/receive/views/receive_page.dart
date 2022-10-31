import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:platform/platform.dart';

import 'package:silkroad/utils/views/alternate_action_button.dart';
import 'package:silkroad/utils/models/animated_list_item_model.dart';
import 'package:silkroad/app_theme.dart';
import 'package:silkroad/global.dart';
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

class ReceivePageState extends State<ReceivePage>
    with RouteAware
{
  final _listKey = GlobalKey<AnimatedListState>();
  late AnimatedListItemModel<ReceiveItem> _receiveList;
  late final ReceiveProvider provider;

  final List<ReceiveItem> _debugReceiveItems = [
    ReceiveItem(iconData: Icons.system_update, name: "system", data: Uint8List(1025), sender: "update"),
    ReceiveItem(iconData: Icons.add_moderator, name: "moderator", data: Uint8List(0), sender: "adder"),
    ReceiveItem(iconData: Icons.add_task, name: "task", data: Uint8List(1024*1024), sender: "adder"),
    ReceiveItem(iconData: Icons.wifi_tethering_error_outlined, name: "error", data: Uint8List(6541), sender: "buglover"),
    ReceiveItem(iconData: Icons.volume_mute_sharp, name: "volume", data: Uint8List(65536), sender: "pin"),
    ReceiveItem(iconData: Icons.video_stable, name: "video", data: Uint8List(10), sender: "ummm"),
    ReceiveItem(iconData: Icons.turn_sharp_right, name: "turn", data: Uint8List(1024*1024*3), sender: "right"),
    ReceiveItem(iconData: Icons.timer_10, name: "timer", data: Uint8List(645891), sender: "cool"),
  ];

  @override
  void initState() {
    super.initState();
    _receiveList = AnimatedListItemModel<ReceiveItem>(
      listKey: _listKey,
      removedItemBuilder: _removeItem,
    );
    provider = ReceiveProvider(platform: widget.platform, receiveList: _receiveList);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    kRouteObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    kRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPop() {
    provider.close();
  }

  @override
  void didPushNext() {
    provider.close();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => provider,
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
      platform: widget.platform,
      index: index,
      iconData: _receiveList[index].iconData,
      name: _receiveList[index].name,
      size: _receiveList[index].sizeStr,
      sender: _receiveList[index].sender,
      animation: animation,
      onSave: (context) => provider.save(index),
      onDelete: (context) => provider.removeAt(index),
    );
  }

  Widget _removeItem(ReceiveItem item, int index, BuildContext context, Animation<double> animation)
  {
    return ReceiveListItemRemoving(
      platform: widget.platform,
      index: index,
      iconData: item.iconData,
      name: item.name,
      size: item.sizeStr,
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

            Consumer<ReceiveProvider>(
              builder: (context, provider, child) => AlternateActionButton(
                enabled: provider.isEnableIp(provider.currentIp),
                startIcon: Icons.play_arrow,
                endIcon: Icons.pause,
                progressIndicatorColor: Colors.blue,
                iconColor: AppTheme.getForegroundColor(context),
                onTap: (state){
                  if(state == AlternateActionStatus.active){
                    provider.open();
                  }
                  else{
                    provider.close();
                  }
                },
              ),
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
      child: Consumer<ReceiveProvider>(
        builder: (context, provider, child) => DropdownButton(
            value: provider.currentIp,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 30,
            isExpanded: true,
            underline: DropdownButtonHideUnderline(child: Container()),
            elevation: 0,
            onChanged: (address) => provider.selectIp(address),
            items: provider.ipList.map((address) =>
                DropdownMenuItem(value: address, child: Text(address)))
                .toList(),
          )
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
            Consumer<ReceiveProvider>(builder: (context, provider, child){
              return Text(
                provider.currentIp,
                style: TextStyle(
                  color: AppTheme.getForegroundColor(context),
                ),
              );
            }),

            Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.arrow_drop_down,
                color: AppTheme.getForegroundColor(context),
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
        return SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CupertinoPicker(
              itemExtent: 40,
              children: provider.ipList.map((address) => Text(address)).toList(),
              onSelectedItemChanged: (address) {
                provider.selectIp(provider.ipList[address]);
              },
            ),
          ),
        );
      },
    );
  }

}

