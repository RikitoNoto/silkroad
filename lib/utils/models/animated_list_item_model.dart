import 'package:flutter/material.dart';

typedef RemovedItemBuilder<T> = Widget Function(
    T item, int index, BuildContext context, Animation<double> animation);

class AnimatedListItemModel<E> {
  AnimatedListItemModel({
    required this.listKey,
    required this.removedItemBuilder,
  });

  final GlobalKey<AnimatedListState> listKey;
  final List<E> _items = <E>[];
  final RemovedItemBuilder<E> removedItemBuilder;

  AnimatedListState? get _animatedList => listKey.currentState;
  static const _durationDefault = Duration(milliseconds: 1000);

  void insert(int index, E item, {Duration duration = _durationDefault}) {
    _items.insert(index, item);
    _animatedList?.insertItem(index, duration: duration);
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList?.removeItem(
        index,
            (BuildContext context, Animation<double> animation) {
          return removedItemBuilder(removedItem, index, context, animation);
        },
      );
    }
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}
