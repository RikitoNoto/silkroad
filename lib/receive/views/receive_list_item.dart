// 受信リストアイテム
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// 受信リストアイテムウィジェットクラス
class ReceiveListItem extends StatelessWidget{
  const ReceiveListItem({
    required this.iconData,
    required this.name,
    required this.size,
    required this.sender,
    super.key,
  });

  final IconData iconData;    // アイコンデータ
  final String name;          // ファイル名
  final int size;             // ファイルサイズ
  final String sender;        // 送信者名

  static const double _iconSize = 40.0;                     // アイコンサイズ
  static const double _sizeAndSenderWidth = 64.0;           // サイズ&送信者列 横幅
  static const Color _itemBackgroundColor = Colors.white;   // アイテム背景色
  static const Color _itemForegroundColor = Colors.black;   // アイテム内文字色

  // テキストスタイル： ファイル名
  static const TextStyle _fileNameTextStyle = TextStyle(
    color: _itemForegroundColor,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  // テキストスタイル： 送信者
  static const TextStyle _senderTextStyle = TextStyle(
    color: _itemForegroundColor,
    fontSize: 12,
  );
  // テキストスタイル： サイズ
  static const TextStyle _sizeTextStyle = _senderTextStyle;

  @override
  Widget build(BuildContext context)
  {
    return Slidable(
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  // アイコン
                  Icon(iconData,
                    color: _itemForegroundColor,
                    size: _iconSize,
                  ),
                  // ファイル名
                  Flexible(
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
                  ),
                ],
              ),
            ),
            SizedBox(
              width: _sizeAndSenderWidth,
              child: Column(
                children: <Widget>[
                  // ファイルサイズ
                  Flexible(
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
                  ),
                  // 送信者
                  Flexible(
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      startActionPane: ActionPane(
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
      ),
      endActionPane: ActionPane(
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
      ),
    );
  }
//  @override
//  Widget build(BuildContext context)
//  {
//    return Padding(
//      padding: const EdgeInsets.symmetric(vertical: 2),
//      child: ElevatedButton(
//        onPressed: ()=>{},
//        style: ElevatedButton.styleFrom(
//          backgroundColor: _itemBackgroundColor,
//          foregroundColor: _itemForegroundColor,
//          elevation: 5,
//          shape: const ContinuousRectangleBorder(),
//          // side: const BorderSide(
//          //   color: Colors.black,
//          // ),
//        ),
//        child: IntrinsicHeight(
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: [
//              Expanded(
//                child: Row(
//                  children: [
//                    // アイコン
//                    Icon(iconData,
//                      color: _itemForegroundColor,
//                      size: _iconSize,
//                    ),
//                    // ファイル名
//                    Flexible(
//                      child: Container(
//                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                        child: Text(
//                          name,
//                          maxLines: 1,
//                          overflow: TextOverflow.ellipsis,
//                          style: _fileNameTextStyle,
//                          textAlign: TextAlign.left,
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//              SizedBox(
//                width: _sizeAndSenderWidth,
//                child: Column(
//                  children: <Widget>[
//                    // ファイルサイズ
//                    Flexible(
//                      flex: 5,
//                      child: Container(
//                        padding: const EdgeInsets.only(bottom: 2),
//                        alignment: Alignment.bottomRight,
//                        child: Text(size.toString() + 'b',
//                          maxLines: 1,
//                          overflow: TextOverflow.ellipsis,
//                          textAlign: TextAlign.right,
//                          style: _sizeTextStyle,
//                        ),
//                      ),
//                    ),
//                    // 送信者
//                    Flexible(
//                      flex: 5,
//                      child: Container(
//                        padding: const EdgeInsets.only(top: 2),
//                        alignment: Alignment.topRight,
//                        child: Text(sender,
//                          maxLines: 1,
//                          overflow: TextOverflow.ellipsis,
//                          textAlign: TextAlign.right,
//                          style: _senderTextStyle,
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//            ],
//          ),
//        )
//      )
//    );
//  }
}
