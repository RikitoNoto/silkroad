
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:silkroad/receive/repository/receive_item.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  accessorTest();
  sizeTest();
}

void accessorTest(){
  group('test accessor of args', () {
    test('should be access iconData [image]', () {
      ReceiveItem item = ReceiveItem(iconData: Icons.image, name: 'a', data: Uint8List(0), sender: 'a');
      expect(item.iconData, Icons.image);
    });

    test('should be access iconData [copy]', () {
      ReceiveItem item = ReceiveItem(iconData: Icons.copy, name: 'a', data: Uint8List(0), sender: 'a');
      expect(item.iconData, Icons.copy);
    });

    test('should be access name [A]', () {
      ReceiveItem item = ReceiveItem(iconData: Icons.image, name: 'A', data: Uint8List(0), sender: 'a');
      expect(item.name, 'A');
    });

    test('should be access name [B.py]', () {
      ReceiveItem item = ReceiveItem(iconData: Icons.image, name: 'B.py', data: Uint8List(0), sender: 'a');
      expect(item.name, 'B.py');
    });

    test('should be access sender [foo]', () {
      ReceiveItem item = ReceiveItem(iconData: Icons.image, name: 'B.py', data: Uint8List(0), sender: 'foo');
      expect(item.sender, 'foo');
    });

    test('should be access sender [bar]', () {
      ReceiveItem item = ReceiveItem(iconData: Icons.image, name: 'B.py', data: Uint8List(0), sender: 'bar');
      expect(item.sender, 'bar');
    });
  });
}

ReceiveItem createItem({iconData=Icons.image, name='test.dart', data: '', sender: 'no name'}){
  return ReceiveItem(
    iconData: iconData,
    name: name,
    data: Uint8List.fromList(utf8.encode(data)),
    sender: sender);
}

void sizeTest(){
  group('calculate size test', () {
    test('should be return size 0 when empty data', () {
      ReceiveItem item = createItem(data: '');
      expect(item.size, 0);
    });

    test('should be return size 1 when one char', () {
      ReceiveItem item = createItem(data: 'A');
      expect(item.size, 1);
    });

    test('should be return size 1024 when 1024 chars', () {
      ReceiveItem item = createItem(data: 'A');
      expect(item.size, 1);
    });
  });
}
