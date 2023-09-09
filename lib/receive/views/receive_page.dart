import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:platform/platform.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:silkroad/option/option_manager.dart';
import 'package:silkroad/option/params.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:silkroad/utils/views/alternate_action_button.dart';
import 'package:silkroad/utils/models/animated_list_item_model.dart';
import 'package:silkroad/app_theme.dart';
import 'package:silkroad/global.dart';
import 'package:silkroad/utils/views/theme_animated_list_item.dart';
import 'package:silkroad/receive/entity/receive_item.dart';
import 'package:silkroad/receive/providers/receive_provider.dart';
import 'package:silkroad/i18n/translations.g.dart';
import 'package:silkroad/ads/platform_banner_ad.dart';
import 'package:silkroad/ads/ad_helper.dart';

class ReceivePage extends StatefulWidget {
  const ReceivePage({
    super.key,
    required this.platform,
  });

  final Platform platform;

  @override
  State<ReceivePage> createState() => ReceivePageState();
}

class ReceivePageState extends State<ReceivePage> with RouteAware {
  final _listKey = GlobalKey<AnimatedListState>();
  late AnimatedListItemModel<ReceiveItem> _receiveList;
  late final ReceiveProvider provider;
  BannerAd? _bannerAd;

  late final TutorialCoachMark _tutorialCoachMark;
  final GlobalKey _keyIpAddressSelector = GlobalKey();
  final GlobalKey _keyOpenButton = GlobalKey();

  final List<ReceiveItem> _debugReceiveItems = [
    ReceiveItem(
        iconData: Icons.system_update,
        name: "system",
        data: Uint8List(1025),
        sender: "update"),
    ReceiveItem(
        iconData: Icons.add_moderator,
        name: "moderator",
        data: Uint8List(0),
        sender: "adder"),
    ReceiveItem(
        iconData: Icons.add_task,
        name: "task",
        data: Uint8List(1024 * 1024),
        sender: "adder"),
    ReceiveItem(
        iconData: Icons.wifi_tethering_error_outlined,
        name: "error",
        data: Uint8List(6541),
        sender: "buglover"),
    ReceiveItem(
        iconData: Icons.volume_mute_sharp,
        name: "volume",
        data: Uint8List(65536),
        sender: "pin"),
    ReceiveItem(
        iconData: Icons.video_stable,
        name: "video",
        data: Uint8List(10),
        sender: "ummm"),
    ReceiveItem(
        iconData: Icons.turn_sharp_right,
        name: "turn",
        data: Uint8List(1024 * 1024 * 3),
        sender: "right"),
    ReceiveItem(
        iconData: Icons.timer_10,
        name: "timer",
        data: Uint8List(645891),
        sender: "cool"),
  ];

  @override
  void initState() {
    super.initState();
    _receiveList = AnimatedListItemModel<ReceiveItem>(
      listKey: _listKey,
      removedItemBuilder: _removeItem,
    );
    provider =
        ReceiveProvider(platform: widget.platform, receiveList: _receiveList);

    AdHelper(platform: widget.platform).initBannerAd(
        onAdLoaded: (ad) => setState(() {
              _bannerAd = ad as BannerAd;
            }));

    // if the tutorial has never been displayed, show the tutorial.
    final isShowed =
        OptionManager().get(Params.isShowTutorialReceive.toString()) as bool?;
    if (isShowed == null || !isShowed) {
      _createTutorial();
      Future.delayed(Duration.zero, _showTutorial);
    }
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

  void _showTutorial() {
    _tutorialCoachMark.show(context: context);
  }

  void _createTutorial() {
    _tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: AppTheme.appIconColor2,
      textSkip: t.tutorial.skip,
      paddingFocus: 10,
      opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onFinish: () {
        // Notify provider that it viewed the tutorial.
        provider.endTutorial();
      },
    );
  }

  TargetFocus _createTarget({
    required GlobalKey<State<StatefulWidget>> key,
    AlignmentGeometry alignSkip = Alignment.bottomRight,
    ContentAlign align = ContentAlign.bottom,
    required String text,
    ShapeLightFocus? shape,
    double? radius,
  }) {
    return TargetFocus(
      identify: key.toString(),
      keyTarget: key,
      alignSkip: alignSkip,
      enableOverlayTab: true,
      shape: shape,
      radius: radius,
      contents: [
        TargetContent(
          align: align,
          builder: (context, controller) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    // ip address field
    targets.add(
      _createTarget(
        key: _keyIpAddressSelector,
        text: t.receive.tutorial.ipAddressSelector,
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );

    // file select field
    targets.add(
      _createTarget(
        key: _keyOpenButton,
        text: t.receive.tutorial.openButton,
      ),
    );
    return targets;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => provider,
      child: Scaffold(
          appBar: AppBar(
            title: Text(t.actions.receive),
            actions: _getDebugActions(),
          ),
          body: _buildBody(context)),
    );
  }

  List<Widget> _getDebugActions() {
    List<Widget> debugActions = [];
    if (kDebugMode) {
      debugActions.add(IconButton(
        icon: const Icon(Icons.add_circle),
        onPressed: _debugInsertItem,
      ));

      debugActions.add(
        IconButton(
          icon: const Icon(Icons.remove_circle),
          onPressed: _debugRemoveItem,
        ),
      );
    }

    return debugActions;
  }

  void _debugInsertItem() {
    _receiveList.insert(_receiveList.length,
        _debugReceiveItems[_receiveList.length % _debugReceiveItems.length]);
  }

  void _debugRemoveItem() {
    if (_receiveList.length > 0) {
      setState(() {
        _receiveList.removeAt(0);
      });
    }
  }

  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    return AddListItem(
      platform: widget.platform,
      title: _ListItemTitle(
        icon: _receiveList[index].iconData,
        name: _receiveList[index].name,
      ),
      leading: _ListItemLeading(
        sender: _receiveList[index].sender,
        size: _receiveList[index].sizeStr,
      ),
      animation: animation,
      index: index,
      onSelect: (context) => provider.save(index),
      onDelete: (context) => provider.removeAt(index),
    );
  }

  Widget _removeItem(ReceiveItem item, int index, BuildContext context,
      Animation<double> animation) {
    return RemoveListItem(
      platform: widget.platform,
      index: index,
      title: _ListItemTitle(
        icon: item.iconData,
        name: item.name,
      ),
      leading: _ListItemLeading(
        sender: item.sender,
        size: item.sizeStr,
      ),
      animation: animation,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(children: [
      // input field
      Row(
        children: [
          Expanded(
            key: _keyIpAddressSelector,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: _buildIpDisplay(context),
            ),
          ),
          Consumer<ReceiveProvider>(
            builder: (context, provider, child) => AlternateActionButton(
              key: _keyOpenButton,
              enabled: provider.isEnableIp(provider.currentIp),
              startIcon: Icons.play_arrow,
              endIcon: Icons.pause,
              onTap: (state) {
                if (state == AlternateActionStatus.active) {
                  provider.open();
                } else {
                  provider.close();
                }
              },
            ),
          ),
        ],
      ),

      // receive list
      Flexible(
        child: AnimatedList(
          key: _listKey,
          itemBuilder: _buildItem,
        ),
      ),
      PlatformBannerAd(
        platform: widget.platform,
        bannerAd: _bannerAd,
      ),
    ]);
  }

  Widget _buildIpDisplay(BuildContext context) {
    Widget ipDisplay;
    switch (widget.platform.operatingSystem) {
      case Platform.iOS:
        ipDisplay = _buildIpListForIos(context);
        break;
      default:
        ipDisplay = _buildIpListForAndroidPc(context);
        break;
    }

    return ipDisplay;
  }

  Widget _buildIpListForAndroidPc(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Consumer<ReceiveProvider>(
        builder: (context, provider, child) => DropdownButton(
          value: provider.currentIp,
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 30,
          isExpanded: true,
          underline: DropdownButtonHideUnderline(child: Container()),
          onChanged: (address) => provider.selectIp(address),
          items: provider.ipList
              .map((address) =>
                  DropdownMenuItem(value: address, child: Text(address)))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildIpListForIos(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(5),
      ),
      child: CupertinoButton(
        child: Stack(
          children: [
            Consumer<ReceiveProvider>(builder: (context, provider, child) {
              return Text(
                provider.currentIp,
              );
            }),
            const Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.arrow_drop_down,
              ),
            ),
          ],
        ),
        onPressed: () {
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
              children:
                  provider.ipList.map((address) => Text(address)).toList(),
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

class _ListItemTitle extends StatelessWidget {
  const _ListItemTitle({
    required this.icon,
    required this.name,
  });

  final IconData icon;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          // padding: const EdgeInsets.all(5.0),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            // color: AppTheme.appIconColor2,
          ),
          child: Icon(
            icon,
            // color: Colors.white,
            size: 30.0,
          ),
        ),
        Flexible(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 20,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}

class _ListItemLeading extends StatelessWidget {
  const _ListItemLeading({
    required this.size,
    required this.sender,
  });

  final String size;
  final String sender;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64.0,
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.only(bottom: 2),
                alignment: Alignment.bottomRight,
                child: Text(
                  size,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.only(top: 2),
                alignment: Alignment.topRight,
                child: Text(
                  sender,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
