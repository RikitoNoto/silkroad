import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

///
/// 受信リストアイテムビルダー
///
mixin _ListItemBuilder{
  static const Color _itemBackgroundColor = Colors.white;   /// アイテム背景色
  static const Color _itemForegroundColor = Colors.black;   /// アイテム内文字色

  /// テキストスタイル： 受信者
  static const TextStyle _receiverTextStyle = TextStyle(
    color: _itemForegroundColor,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  /// テキストスタイル： デバイス名
  static const TextStyle _deviceNameTextStyle = TextStyle(
    color: _itemForegroundColor,
    fontSize: 12,
  );

  /// アイテムデコレーション
  static const BoxDecoration _decorationItem = BoxDecoration(
    color: _itemBackgroundColor,
    border: Border(
      bottom: BorderSide(
        color: Colors.black,
        width: 1,
      ),
    ),
  );

  static Widget build({required deviceName, required receiver,})
  {
    return Slidable(
      startActionPane: _buildStartAction(),
      endActionPane: _buildEndAction(),
      child: Container(
        decoration: _decorationItem,
        child: IntrinsicHeight(
          child: Column(
            children: [
              _buildReceiver(receiver),
              _buildDeviceName(deviceName),
            ],
          ),
        ),
      ),
    );
  }

  static ActionPane _buildStartAction()
  {
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          // An action can be bigger than the others.
          onPressed: (BuildContext context) => {},
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
      ],
    );
  }

  static ActionPane _buildEndAction()
  {
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          // An action can be bigger than the others.
          flex: 2,
          onPressed: (BuildContext context) => {},
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          icon: Icons.send,
          label: 'Send',
        ),
      ],
    );
  }

  static Widget _buildReceiver(String name)
  {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.topLeft,
        child: Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: _receiverTextStyle,
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  static Widget _buildDeviceName(String sender)
  {
    return Container(
      padding: const EdgeInsets.only(top: 2, left: 20, bottom: 5),
      alignment: Alignment.bottomLeft,
      child: Text(sender,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
        style: _deviceNameTextStyle,
      ),
    );
  }
}

///
/// 送信リストアイテムクラス
///
class SendListItem extends StatelessWidget{
  SendListItem({
    required this.deviceName,
    required this.receiver,
    required this.animation,
    super.key,
  });

  final String deviceName;            /// 受信デバイス名
  final String receiver;              /// 受信者名
  final Animation<double> animation;  /// サイズアニメーション

  final Animatable<Offset> _offsetAnimation = Tween<Offset>(
    end: Offset.zero,
    begin: const Offset(1.5, 0.0),
  ).chain(CurveTween(
    curve: Curves.bounceOut,
  ));

  @override
  Widget build(BuildContext context)
  {
    return SlideTransition(
      position: animation.drive(_offsetAnimation),
      child: _ListItemBuilder.build(deviceName: deviceName, receiver: receiver),
    );
  }
}

///
/// 送信リストアイテムクラス
/// 削除用
///
class SendListItemRemoving extends StatelessWidget{
  const SendListItemRemoving({
    required this.deviceName,
    required this.receiver,
    required this.animation,
    super.key,
  });

  final String deviceName;            /// 受信デバイス名
  final String receiver;              /// 受信者名
  final Animation<double> animation;  /// サイズアニメーション


  @override
  Widget build(BuildContext context)
  {
    return SizeTransition(
      sizeFactor: animation,
      child: _ListItemBuilder.build(deviceName: deviceName, receiver: receiver),
    );
  }
}
