import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

///
/// 受信リストアイテムクラス
///
class ReceiveListItem extends StatelessWidget{
  const ReceiveListItem({
    required this.iconData,
    required this.name,
    required this.size,
    required this.sender,
    required this.animation,
    super.key,
  });

  final IconData iconData;            /// アイコンデータ
  final String name;                  /// ファイル名
  final int size;                     /// ファイルサイズ
  final String sender;                /// 送信者名
  final Animation<double> animation;  /// サイズアニメーション


  static const double _iconSize = 40.0;                     /// アイコンサイズ
  static const double _sizeAndSenderWidth = 64.0;           /// サイズ&送信者列 横幅
  static const Color _itemBackgroundColor = Colors.white;   /// アイテム背景色
  static const Color _itemForegroundColor = Colors.black;   /// アイテム内文字色

  /// テキストスタイル： ファイル名
  static const TextStyle _fileNameTextStyle = TextStyle(
    color: _itemForegroundColor,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  /// テキストスタイル： 送信者
  static const TextStyle _senderTextStyle = TextStyle(
    color: _itemForegroundColor,
    fontSize: 12,
  );

  /// テキストスタイル： サイズ
  static const TextStyle _sizeTextStyle = _senderTextStyle;

  /// アイテムデコレーション
  static const BoxDecoration _decorationItem = BoxDecoration(
    border: Border(
      bottom: BorderSide(
        color: Colors.black,
        width: 1,
      )
    ),
  );

  @override
  Widget build(BuildContext context)
  {
    return SizeTransition(
      sizeFactor: animation,
      child: Slidable(
        startActionPane: _buildStartAction(),
        endActionPane: _buildEndAction(),
        child: Container(
          decoration: _decorationItem,
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _buildIcon(),     // アイコン
                      _buildFileName(), // ファイル名
                    ],
                  ),
                ),
                SizedBox(
                  width: _sizeAndSenderWidth,
                  child: Column(
                    children: <Widget>[
                      _buildFileSize(),  // ファイルサイズ
                      _buildSender(),   // 送信者
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ActionPane _buildStartAction()
  {
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          // An action can be bigger than the others.
          flex: 4,
          onPressed: (BuildContext context) => {},
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
      ],
    );
  }

  ActionPane _buildEndAction()
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
          icon: Icons.save,
          label: 'Save',
        ),
        SlidableAction(
          flex: 2,
          onPressed: (BuildContext context) => {},
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          icon: Icons.more,
          label: 'More',
        ),
      ],
    );
  }

  Widget _buildIcon()
  {
    return Icon(iconData,
      color: _itemForegroundColor,
      size: _iconSize,
    );
  }

  Widget _buildFileName()
  {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: _fileNameTextStyle,
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget _buildFileSize()
  {
    return Flexible(
      flex: 5,
      child: Container(
        padding: const EdgeInsets.only(bottom: 2),
        alignment: Alignment.bottomRight,
        child: Text(size.toString() + 'b',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
          style: _sizeTextStyle,
        ),
      ),
    );
  }

  Widget _buildSender()
  {
    return Flexible(
      flex: 5,
      child: Container(
        padding: const EdgeInsets.only(top: 2),
        alignment: Alignment.topRight,
        child: Text(sender,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
          style: _senderTextStyle,
        ),
      ),
    );
  }
}
