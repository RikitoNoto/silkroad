import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:platform/platform.dart';

import 'package:silkroad/app_theme.dart';


///
/// receive item builder
///
mixin _ListItemBuilderMobile{

  Widget buildListItemMobile(
      BuildContext context,
      {
        required Widget child,
        EdgeInsetsGeometry? padding,
        void Function(BuildContext context)? onDelete,
        void Function(BuildContext context)? onSave,
        Color? backgroundColor,
      })
  {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      padding: padding ?? EdgeInsets.zero,
      child: Slidable(
        startActionPane: _buildStartAction(onDelete),
        endActionPane: _buildEndAction(onSave),
        child: child,//_buildCardItem(name: name, size: size, sender: sender, iconData: iconData),
      ),
    );
  }

  static ActionPane _buildStartAction(void Function(BuildContext context)? deleteAction){
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          // An action can be bigger than the others.
          flex: 4,
          onPressed: deleteAction,
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
      ],
    );
  }

  static ActionPane _buildEndAction(void Function(BuildContext context)? saveAction){
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          // An action can be bigger than the others.
          flex: 2,
          onPressed: saveAction,
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          icon: Icons.save,
          label: 'Save',
        ),
        // SlidableAction(
        //   flex: 2,
        //   onPressed: (BuildContext context) => {},
        //   backgroundColor: Colors.white,
        //   foregroundColor: Colors.black,
        //   icon: Icons.more,
        //   label: 'More',
        // ),
      ],
    );
  }

}

mixin _ListItemBuilderPc {

  Widget buildListItemPc(
      BuildContext context,
      {
        required Widget child,
        required String name,
        EdgeInsetsGeometry? padding,
        void Function(BuildContext context)? onDelete,
        void Function(BuildContext context)? onSave,
      })
  {
    return ElevatedButton(
      onPressed: (){
        showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
                title: Text(name),
                children: <Widget>[
                  SimpleDialogOption(
                    onPressed: () => Navigator.pop(context),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('Save',)
                          ),
                        ]
                      ),
                    ),
                  ),
                  SimpleDialogOption(
                    onPressed: () => Navigator.pop(context),
                    child: Container(
                      child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Text('Delete', style: TextStyle(color: Colors.red),)
                            ),
                          ]
                      ),
                    ),
                  ),
                ],
            );
          },
        );
      },
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0.0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: MaterialStateProperty.all<Color>(AppTheme.getBackgroundColor(context)),
      ),
      child: child,
    );
  }
}

abstract class ReceiveListItemBase extends StatelessWidget with _ListItemBuilderPc, _ListItemBuilderMobile{
  const ReceiveListItemBase({super.key});
  static const double _iconSize = 30.0;                     /// icon size
  static const double _sizeAndSenderWidth = 64.0;           /// size and sender column width

  static const Color _itemLightModeColor = Colors.white;      /// white mode item color
  static const Color _itemDarkModeColor = Colors.black54;     /// dark mode item color

  static Color _itemBackgroundColor = Colors.white;   /// item back ground color
  static Color _itemForegroundColor = Colors.black;   /// item font color

  /// text style： file name
  static TextStyle get _fileNameTextStyle => TextStyle(
    color: _itemForegroundColor,
    fontSize: 20,
    // fontWeight: FontWeight.bold,
  );

  /// text style： sender
  static TextStyle get _senderTextStyle => TextStyle(
    color: _itemForegroundColor,
    fontSize: 12,
  );

  /// text style： file size
  static TextStyle get _sizeTextStyle => _senderTextStyle;

  // /// item decoration
  // static BoxDecoration get _decorationItem => BoxDecoration(
  //   color: _itemBackgroundColor,
  // );

  Widget _buildListItem(BuildContext context,
                      {
                        required Platform platform,
                        required index,
                        required iconData,
                        required name,
                        required size,
                        required sender,
                        void Function(BuildContext context)? onDelete,
                        void Function(BuildContext context)? onSave,
                      })
  {

    // is light mode.
    if(MediaQuery.platformBrightnessOf(context) == Brightness.light){
      _itemForegroundColor = Theme.of(context).textTheme.bodyText1?.color ?? _itemForegroundColor;
      _itemBackgroundColor = _itemLightModeColor;
    }
    // is dark mode.
    else{
      _itemForegroundColor = Theme.of(context).textTheme.bodyText1?.color ?? _itemForegroundColor;
      _itemBackgroundColor = _itemDarkModeColor;
    }

    switch(platform.operatingSystem){
      case Platform.iOS:
      case Platform.android:
        return buildListItemMobile(
          context,
          onSave: onSave,
          onDelete: onDelete,
          backgroundColor: _itemBackgroundColor,
          child: _buildCardItem(context, iconData: iconData, name: name, size: size, sender: sender,),
        );

      default:
        return buildListItemPc(
          context,
          name: name,
          onSave: onSave,
          onDelete: onDelete,
          child: _buildCardItem(context, iconData: iconData, name: name, size: size, sender: sender),
        );
    }
  }

  Widget _buildCardItem(
    BuildContext context,
    {
      required String name,
      IconData? iconData,
      required String size,
      required String sender,
    })
  {

    return Container(
      // decoration: _decorationItem,
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
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Column(
                  children: <Widget>[
                    _buildFileSize(size),   // file size
                    _buildSender(sender),   // sender
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(IconData? iconData)
  {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: const BoxDecoration(
          // borderRadius: BorderRadius.circular(100),
          shape: BoxShape.circle,
          color: AppTheme.appIconColor2,
        ),
        child: Icon(iconData,
          color: Colors.white,
          size: _iconSize,

        ),
      ),
    );
  }

  Widget _buildFileName(String name)
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

  Widget _buildFileSize(String size)
  {
    return Flexible(
      flex: 5,
      child: Container(
        padding: const EdgeInsets.only(bottom: 2),
        alignment: Alignment.bottomRight,
        child: Text(size.toString(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
          style: _sizeTextStyle,
        ),
      ),
    );
  }

  Widget _buildSender(String sender)
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

// ///
// /// receive item builder
// ///
// mixin _ListItemBuilder{
//   static const double _iconSize = 30.0;                     /// icon size
//   static const double _sizeAndSenderWidth = 64.0;           /// size and sender column width
//
//   static const Color _itemLightModeColor = Colors.white;      /// white mode item color
//   static const Color _itemDarkModeColor = Colors.black54;     /// dark mode item color
//
//   static Color _itemBackgroundColor = Colors.white;   /// item back ground color
//   static Color _itemForegroundColor = Colors.black;   /// item font color
//
//   /// text style： file name
//   static TextStyle get _fileNameTextStyle => TextStyle(
//     color: _itemForegroundColor,
//     fontSize: 20,
//     // fontWeight: FontWeight.bold,
//   );
//
//   /// text style： sender
//   static TextStyle get _senderTextStyle => TextStyle(
//     color: _itemForegroundColor,
//     fontSize: 12,
//   );
//
//   /// text style： file size
//   static TextStyle get _sizeTextStyle => _senderTextStyle;
//
//   /// item decoration
//   static BoxDecoration get _decorationItem => BoxDecoration(
//     color: _itemBackgroundColor,
//   );
//
//   static const EdgeInsetsGeometry _itemPadding = EdgeInsets.only(top: 0);
//
//   static Widget build(
//     BuildContext context,
//     {
//       required index,
//       required iconData,
//       required name,
//       required size,
//       required sender,
//       void Function(BuildContext context)? onDelete,
//       void Function(BuildContext context)? onSave,
//     })
//   {
//     // is light mode.
//     if(MediaQuery.platformBrightnessOf(context) == Brightness.light){
//       _itemForegroundColor = Theme.of(context).textTheme.bodyText1?.color ?? _itemForegroundColor;
//       _itemBackgroundColor = _itemLightModeColor;
//     }
//     // is dark mode.
//     else{
//       _itemForegroundColor = Theme.of(context).textTheme.bodyText1?.color ?? _itemForegroundColor;
//       _itemBackgroundColor = _itemDarkModeColor;
//     }
//
//     return Padding(
//       padding: _itemPadding,
//       child: Slidable(
//         startActionPane: _buildStartAction(onDelete),
//         endActionPane: _buildEndAction(onSave),
//         child: _buildCardItem(name: name, size: size, sender: sender, iconData: iconData),
//       ),
//     );
//   }
//
//   static ActionPane _buildStartAction(void Function(BuildContext context)? deleteAction)
//   {
//     return ActionPane(
//       motion: const ScrollMotion(),
//       children: [
//         SlidableAction(
//           // An action can be bigger than the others.
//           flex: 4,
//           onPressed: deleteAction,
//           backgroundColor: Colors.red,
//           foregroundColor: Colors.white,
//           icon: Icons.delete,
//           label: 'Delete',
//         ),
//       ],
//     );
//   }
//
//   static ActionPane _buildEndAction(void Function(BuildContext context)? saveAction)
//   {
//     return ActionPane(
//       motion: const ScrollMotion(),
//       children: [
//         SlidableAction(
//           // An action can be bigger than the others.
//           flex: 2,
//           onPressed: saveAction,
//           backgroundColor: Colors.green,
//           foregroundColor: Colors.white,
//           icon: Icons.save,
//           label: 'Save',
//         ),
//         // SlidableAction(
//         //   flex: 2,
//         //   onPressed: (BuildContext context) => {},
//         //   backgroundColor: Colors.white,
//         //   foregroundColor: Colors.black,
//         //   icon: Icons.more,
//         //   label: 'More',
//         // ),
//       ],
//     );
//   }
//
//   static Widget _buildCardItem(
//     {
//       required String name,
//       IconData? iconData,
//       required String size,
//       required String sender,
//     }
//   ){
//     return Container(
//       decoration: _decorationItem,
//       child: IntrinsicHeight(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Row(
//                 children: [
//                   _buildIcon(iconData),     // icon
//                   _buildFileName(name),     // file name
//                 ],
//               ),
//             ),
//             SizedBox(
//               width: _sizeAndSenderWidth,
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 8),
//                 child: Column(
//                   children: <Widget>[
//                     _buildFileSize(size),   // file size
//                     _buildSender(sender),   // sender
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   static Widget _buildIcon(IconData? iconData)
//   {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
//       child: Container(
//         padding: const EdgeInsets.all(5.0),
//         decoration: const BoxDecoration(
//           // borderRadius: BorderRadius.circular(100),
//           shape: BoxShape.circle,
//           color: AppTheme.appIconColor2,
//         ),
//         child: Icon(iconData,
//           color: Colors.white,
//           size: _iconSize,
//
//         ),
//       ),
//     );
//   }
//
//   static Widget _buildFileName(String name)
//   {
//     return Flexible(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//         child: Text(
//           name,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           style: _fileNameTextStyle,
//           textAlign: TextAlign.left,
//         ),
//       ),
//     );
//   }
//
//   static Widget _buildFileSize(String size)
//   {
//     return Flexible(
//       flex: 5,
//       child: Container(
//         padding: const EdgeInsets.only(bottom: 2),
//         alignment: Alignment.bottomRight,
//         child: Text(size.toString(),
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           textAlign: TextAlign.right,
//           style: _sizeTextStyle,
//         ),
//       ),
//     );
//   }
//
//   static Widget _buildSender(String sender)
//   {
//     return Flexible(
//       flex: 5,
//       child: Container(
//         padding: const EdgeInsets.only(top: 2),
//         alignment: Alignment.topRight,
//         child: Text(sender,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           textAlign: TextAlign.right,
//           style: _senderTextStyle,
//         ),
//       ),
//     );
//   }
// }

///
/// Receive list item for add.
///
class ReceiveListItem extends ReceiveListItemBase{
  ReceiveListItem({
    required this.platform,
    required this.iconData,
    required this.name,
    required this.size,
    required this.sender,
    required this.animation,
    required this.index,
    this.onSave,
    this.onDelete,
    super.key,
  });

  final int index;
  final IconData iconData;            /// icon
  final String name;                  /// file name
  final String size;                  /// file size
  final String sender;                /// sender name
  final Animation<double> animation;  /// size animation
  final void Function(BuildContext context)? onSave;
  final void Function(BuildContext context)? onDelete;
  final Platform platform;

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
      child: _buildListItem(
        context,
        platform: platform,
        index: index,
        iconData: iconData,
        name: name,
        size: size,
        sender: sender,
        onSave: onSave,
        onDelete: onDelete,
      ),
    );
  }
}

///
/// Receive list item for remove.
///
class ReceiveListItemRemoving extends ReceiveListItemBase{
  const ReceiveListItemRemoving({
    required this.platform,
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
  final String size;                  /// file size
  final String sender;                /// sender name
  final Animation<double> animation;  /// size animation
  final Platform platform;


  @override
  Widget build(BuildContext context)
  {
    return SizeTransition(
      sizeFactor: animation,
      child: _buildListItem(
        context,
        platform: platform,
        index: index,
        iconData: iconData,
        name: name,
        size: size,
        sender: sender
      ),
    );
  }
}
