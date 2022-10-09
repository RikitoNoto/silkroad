import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:silkroad/utils/models/animated_list_item_model.dart';

import 'animated_list_item_model_test.mocks.dart';

late AnimatedListItemModel<int> kModel;
late MockLabeledGlobalKey<AnimatedListState> kListKey;
late MockAnimatedListState kAnimatedListState;


Widget _removeItemBuilder(int item, int index, BuildContext context, Animation<double> animation){
  return const Text('test');
}

@GenerateMocks([LabeledGlobalKey])
@GenerateMocks([AnimatedListState])
void main() {
  setUp((){
    kListKey = MockLabeledGlobalKey<AnimatedListState>();
    kAnimatedListState = MockAnimatedListState();
    when(kListKey.currentState).thenReturn(kAnimatedListState);
    when(kAnimatedListState.insertItem(any)).thenReturn(null);
    when(kAnimatedListState.removeItem(any, any)).thenReturn(null);
    kModel = AnimatedListItemModel(listKey: kListKey, removedItemBuilder: _removeItemBuilder);
  });
  keyTest();
}

void checkAppend({required int item, required int expectPosition, Duration? duration}){
  kModel.append(item);
  verify(kAnimatedListState.insertItem(expectPosition, duration: duration ?? anyNamed('duration')));
}

void checkInsert({required int position, required int item, required int expectPosition, Duration? duration}){
  kModel.insert(position, item);
  verify(kAnimatedListState.insertItem(expectPosition, duration: duration ?? anyNamed('duration')));
}

void insertSomeItem(int count){
  for(int i=0; i<count ; i++){
    kModel.append(i);
  }
}

void keyTest() {
  group('append test', () {
    test('should be append the zero when call list add method', () async {
      checkAppend(item: 0, expectPosition: 0);
    });

    test('should be append the one when call list add method', () async {
      checkAppend(item: 1, expectPosition: 0);
    });

    test('should be append twice', () async {
      checkAppend(item: 1, expectPosition: 0);
      checkAppend(item: 5, expectPosition: 1);
    });
  });

  group('insert test', () {
    test('should be insert the zero into first', () async {
      checkInsert(position: 0, item: 0, expectPosition: 0);
    });

    test('should be insert tow items into first', () async {
      checkInsert(position: 0, item: 0, expectPosition: 0);
      checkInsert(position: 0, item: 1, expectPosition: 0);
    });

    test('should be insert tow items into last', () async {
      checkInsert(position: 0, item: 0, expectPosition: 0);
      checkInsert(position: 1, item: 1, expectPosition: 1);
    });

    group('remove at test', () {
      test('should be remove first [zero]', () async {
        insertSomeItem(1);
        kModel.removeAt(0);
        verify(kAnimatedListState.removeItem(0, any));
      });


      test('should be remove second [one]', () async {
        insertSomeItem(2);
        kModel.removeAt(1);
        verify(kAnimatedListState.removeItem(1, any));
      });
    });

    group('clear test', () {
      test('should be clear one item', () async {
        insertSomeItem(1);
        kModel.clear();
        verify(kAnimatedListState.removeItem(0, any));
      });

      test('should be clear two item', () async {
        insertSomeItem(2);
        kModel.clear();
        expect(verify(kAnimatedListState.removeItem(any, any)).callCount, 2);
      });

      test('should be clear one hundred item', () async {
        insertSomeItem(100);
        kModel.clear();
        expect(verify(kAnimatedListState.removeItem(any, any)).callCount, 100);
      });
    });
  });
}
