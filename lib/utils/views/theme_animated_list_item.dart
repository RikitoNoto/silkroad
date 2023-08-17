import 'package:flutter/material.dart';
import 'package:platform/platform.dart';

import 'package:silkroad/app_theme.dart';

///
/// receive item builder
///
class _ThemeAnimatedListItemBase extends StatelessWidget {
  const _ThemeAnimatedListItemBase({
    required this.platform,
    required this.index,
    required this.title,
    this.padding,
    this.leading,
    this.onDelete,
    this.onSelect,
  });

  final Platform platform;
  final int index;
  final Widget title;
  final Widget? leading;
  final EdgeInsetsGeometry? padding;

  final void Function(BuildContext context)? onDelete;
  final void Function(BuildContext context)? onSelect;

  @override
  Widget build(BuildContext context) {
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
      child: IntrinsicHeight(
        child: Padding(
          padding: padding ??
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                        child: title,
                      ),
                    )
                  ],
                ),
              ),
              if (leading != null) leading!,
              IconButton(
                onPressed: () => onDelete?.call(context),
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///
/// list item for add.
///
class AddListItem extends StatelessWidget {
  AddListItem({
    required this.platform,
    required this.title,
    required this.animation,
    required this.index,
    this.leading,
    this.onSelect,
    this.onDelete,
    this.padding,
    super.key,
  });

  final int index;

  final Widget title;

  final Widget? leading;

  /// animation
  final Animation<double> animation;

  final EdgeInsetsGeometry? padding;

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
      child: _ThemeAnimatedListItemBase(
        platform: platform,
        index: index,
        title: title,
        leading: leading,
        padding: padding,
        onSelect: onSelect,
        onDelete: onDelete,
      ),
    );
  }
}

///
/// list item for remove.
///
class RemoveListItem extends StatelessWidget {
  const RemoveListItem({
    required this.platform,
    required this.title,
    required this.animation,
    required this.index,
    this.leading,
    this.padding,
    super.key,
  });

  final int index;

  final Widget title;

  final Widget? leading;

  /// sender name
  final Animation<double> animation;

  final EdgeInsetsGeometry? padding;

  /// size animation
  final Platform platform;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: _ThemeAnimatedListItemBase(
        platform: platform,
        index: index,
        title: title,
        leading: leading,
        padding: padding,
      ),
    );
  }
}
