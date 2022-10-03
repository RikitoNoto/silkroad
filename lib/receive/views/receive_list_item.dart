import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

///
/// receive item builder
///
mixin _ListItemBuilder{
  static const double _iconSize = 40.0;                     /// icon size
  static const double _sizeAndSenderWidth = 64.0;           /// size and sender column width

  static const Color _itemLightModeColor = Colors.white;      /// white mode item color
  static const Color _itemDarkModeColor = Colors.black54;     /// dark mode item color
  // static const Color _itemDarkModeColorOdd  = Colors.black26;  /// odd numbered item color in dark
  // static const Color _itemDarkModeColorEven = Colors.black54;  /// even numbered item color in dark

  static Color _itemBackgroundColor = Colors.white;   /// item back ground color
  static Color _itemForegroundColor = Colors.black;   /// item font color

  /// text style： file name
  static TextStyle get _fileNameTextStyle => TextStyle(
    color: _itemForegroundColor,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  /// text style： sender
  static TextStyle get _senderTextStyle => TextStyle(
    color: _itemForegroundColor,
    fontSize: 12,
  );

  /// text style： file size
  static TextStyle get _sizeTextStyle => _senderTextStyle;

  /// item decoration
  static BoxDecoration get _decorationItem => BoxDecoration(
    color: _itemBackgroundColor,
  );

  static const EdgeInsetsGeometry _itemPadding = EdgeInsets.only(top: 0);

  static Widget build(BuildContext context, {required index, required iconData, required name, required size, required sender,})
  {
    // is light mode.
    if(MediaQuery.platformBrightnessOf(context) == Brightness.light){
      _itemForegroundColor = Theme.of(context).textTheme.bodyText1?.color ?? _itemForegroundColor;
      _itemBackgroundColor = _itemLightModeColor;
    }
    // is dark mode.
    else{
      _itemForegroundColor = Theme.of(context).textTheme.bodyText1?.color ?? _itemForegroundColor;
      // if(index % 2 == 0){
      //   _itemBackgroundColor = _itemDarkModeColorEven;
      // }
      // else{
      //   _itemBackgroundColor = _itemDarkModeColorOdd;
      // }
      _itemBackgroundColor = _itemDarkModeColor;
    }

    return Padding(
      padding: _itemPadding,
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
                      _buildIcon(iconData),     // icon
                      _buildFileName(name),     // file name
                    ],
                  ),
                ),
                SizedBox(
                  width: _sizeAndSenderWidth,
                  child: Column(
                    children: <Widget>[
                      _buildFileSize(size),   // file size
                      _buildSender(sender),   // sender
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

  static ActionPane _buildStartAction()
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

  static Widget _buildIcon(IconData? iconData)
  {
    return Icon(iconData,
      color: _itemForegroundColor,
      size: _iconSize,
    );
  }

  static Widget _buildFileName(String name)
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

  static Widget _buildFileSize(int size)
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

  static Widget _buildSender(String sender)
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

///
/// Receive list item for add.
///
class ReceiveListItem extends StatelessWidget{
  ReceiveListItem({
    required this.iconData,
    required this.name,
    required this.size,
    required this.sender,
    required this.animation,
    required this.index,
    super.key,
  });

  final int index;
  final IconData iconData;            /// icon
  final String name;                  /// file name
  final int size;                     /// file size
  final String sender;                /// sender name
  final Animation<double> animation;  /// size animation

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
      child: _ListItemBuilder.build(context,index: index, iconData: iconData, name: name, size: size, sender: sender),
    );
  }
}

///
/// Receive list item for remove.
///
class ReceiveListItemRemoving extends StatelessWidget{
  const ReceiveListItemRemoving({
    required this.iconData,
    required this.name,
    required this.size,
    required this.sender,
    required this.animation,
    required this.index,
    super.key,
  });

  final int index;
  final IconData iconData;            /// icon
  final String name;                  /// file name
  final int size;                     /// file size
  final String sender;                /// sender name
  final Animation<double> animation;  /// size animation


  @override
  Widget build(BuildContext context)
  {
    return SizeTransition(
      sizeFactor: animation,
      child: _ListItemBuilder.build(context, index: index, iconData: iconData, name: name, size: size, sender: sender),
    );
  }
}
