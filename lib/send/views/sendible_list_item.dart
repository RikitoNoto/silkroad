import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:platform/platform.dart';

import 'package:silkroad/app_theme.dart';

///
/// receive item builder
///
mixin _ListItemBuilderMobile {
  Widget buildListItemMobile(
    BuildContext context, {
    required Widget child,
    EdgeInsetsGeometry? padding,
    void Function(BuildContext context)? onDelete,
    void Function(BuildContext context)? onSelect,
    Color? backgroundColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      padding: padding ?? EdgeInsets.zero,
      child: Slidable(
        startActionPane: _buildStartAction(onDelete),
        endActionPane: _buildEndAction(onSelect),
        child:
            child, //_buildCardItem(name: name, size: size, sender: sender, iconData: iconData),
      ),
    );
  }

  static ActionPane _buildStartAction(
      void Function(BuildContext context)? deleteAction) {
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

  static ActionPane _buildEndAction(
    void Function(BuildContext context)? action,
  ) {
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          // An action can be bigger than the others.
          flex: 2,
          onPressed: action,
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          icon: Icons.check,
          label: 'Select',
        ),
      ],
    );
  }
}

mixin _ListItemBuilderPc {
  Widget buildListItemPc(
    BuildContext context, {
    required Widget child,
    required String ipAddress,
    EdgeInsetsGeometry? padding,
    void Function(BuildContext context)? onDelete,
    void Function(BuildContext context)? onSelect,
  }) {
    return ElevatedButton(
      onPressed: () {
        onSelect?.call(context);
      },
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0.0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: MaterialStateProperty.all<Color>(
            AppTheme.getBackgroundColor(context)),
      ),
      child: child,
    );
  }
}

abstract class SendibleListItemBase extends StatelessWidget
    with _ListItemBuilderPc, _ListItemBuilderMobile {
  const SendibleListItemBase({super.key});
  static const double _iconSize = 30.0;

  /// icon size
  static const double _sizeAndSenderWidth = 64.0;

  /// size and sender column width

  static const Color _itemLightModeColor = Colors.white;

  /// white mode item color
  static const Color _itemDarkModeColor = Colors.black54;

  /// dark mode item color

  static Color _itemBackgroundColor = Colors.white;

  /// item back ground color
  static Color _itemForegroundColor = Colors.black;

  /// item font color

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

  Widget _buildListItem(
    BuildContext context, {
    required Platform platform,
    required index,
    required sender,
    required String ipAddress,
    void Function(BuildContext context)? onDelete,
    void Function(BuildContext context)? onSelect,
  }) {
    // is light mode.
    if (MediaQuery.platformBrightnessOf(context) == Brightness.light) {
      _itemForegroundColor =
          Theme.of(context).textTheme.bodyLarge?.color ?? _itemForegroundColor;
      _itemBackgroundColor = _itemLightModeColor;
    }
    // is dark mode.
    else {
      _itemForegroundColor =
          Theme.of(context).textTheme.bodyLarge?.color ?? _itemForegroundColor;
      _itemBackgroundColor = _itemDarkModeColor;
    }

    switch (platform.operatingSystem) {
      case Platform.iOS:
      case Platform.android:
        return buildListItemMobile(
          context,
          onSelect: onSelect,
          onDelete: onDelete,
          backgroundColor: _itemBackgroundColor,
          child: _buildCardItem(
            context,
            platform,
            sender: sender,
            ipAddress: ipAddress,
          ),
        );

      default:
        return buildListItemPc(
          context,
          onSelect: onSelect,
          onDelete: onDelete,
          ipAddress: ipAddress,
          child: _buildCardItem(
            context,
            platform,
            sender: sender,
            ipAddress: ipAddress,
          ),
        );
    }
  }

  Widget _buildCardItem(
    BuildContext context,
    Platform platform, {
    required String sender,
    required String ipAddress,
    void Function(BuildContext context)? onDelete,
  }) {
    return Container(
      // decoration: _decorationItem,
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  _buildIpAddress(ipAddress),
                ],
              ),
            ),
            SizedBox(
              width: _sizeAndSenderWidth,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Column(
                  children: <Widget>[
                    _buildSender(sender), // sender
                  ],
                ),
              ),
            ),
            if (platform.operatingSystem != Platform.android &&
                platform.operatingSystem != Platform.iOS)
              IconButton(
                onPressed: () => onDelete?.call(context),
                icon: const Icon(Icons.delete),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIpAddress(String ipAddress) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Text(
          ipAddress,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: _fileNameTextStyle,
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget _buildSender(String sender) {
    return Flexible(
      flex: 5,
      child: Container(
        padding: const EdgeInsets.only(top: 2),
        alignment: Alignment.topRight,
        child: Text(
          sender,
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
/// Sendible list item for add.
///
class SendibleListItem extends SendibleListItemBase {
  SendibleListItem({
    required this.platform,
    required this.sender,
    required this.ipAddress,
    required this.animation,
    required this.index,
    this.onSelect,
    this.onDelete,
    super.key,
  });

  final int index;

  /// file size
  final String sender;

  /// ip address
  final String ipAddress;

  /// sender name
  final Animation<double> animation;

  /// size animation
  final void Function(BuildContext context)? onSelect;
  final void Function(BuildContext context)? onDelete;
  final Platform platform;

  final Animatable<Offset> _offsetAnimation = Tween<Offset>(
    end: Offset.zero,
    begin: const Offset(1.5, 0.0),
  ).chain(CurveTween(
    curve: Curves.bounceIn,
  ));

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation.drive(_offsetAnimation),
      child: _buildListItem(
        context,
        platform: platform,
        index: index,
        ipAddress: ipAddress,
        sender: sender,
        onSelect: onSelect,
        onDelete: onDelete,
      ),
    );
  }
}

///
/// Sendible list item for remove.
///
class SendibleListItemRemoving extends SendibleListItemBase {
  const SendibleListItemRemoving({
    required this.platform,
    required this.ipAddress,
    required this.sender,
    required this.animation,
    required this.index,
    super.key,
  });

  final int index;

  /// file size
  final String sender;

  final String ipAddress;

  /// sender name
  final Animation<double> animation;

  /// size animation
  final Platform platform;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: _buildListItem(context,
          ipAddress: ipAddress,
          platform: platform,
          index: index,
          sender: sender),
    );
  }
}
