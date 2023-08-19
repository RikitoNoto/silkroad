import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import '../../spy/path_provider_spy.dart';

import 'package:silkroad/receive/entity/receive_item.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  kSpyRootDir = Directory(p.join('test', 'temp'));
  kTempDir = Directory(p.join(kSpyRootDir.path, 'temp'));

  accessorTest();
  sizeTest();
  iconTest();

  setUpAll(() {
    PathProviderPlatformSpy.temporaryPath = kTempDir.path;
  });

  setUp(() async {
    await pathProviderSetUp();
  });

  tearDown(() async {
    await pathProviderTearDown();
  });
  tempFileTest();
}

void accessorTest() {
  group('test accessor of args', () {
    test('should be access iconData [image]', () {
      ReceiveItem item = ReceiveItem(
          iconData: Icons.image, name: 'a', data: Uint8List(0), sender: 'a');
      expect(item.iconData, Icons.image);
    });

    test('should be access iconData [copy]', () {
      ReceiveItem item = ReceiveItem(
          iconData: Icons.copy, name: 'a', data: Uint8List(0), sender: 'a');
      expect(item.iconData, Icons.copy);
    });

    test('should be access name [A]', () {
      ReceiveItem item = ReceiveItem(
          iconData: Icons.image, name: 'A', data: Uint8List(0), sender: 'a');
      expect(item.name, 'A');
    });

    test('should be access name [B.py]', () {
      ReceiveItem item = ReceiveItem(
          iconData: Icons.image, name: 'B.py', data: Uint8List(0), sender: 'a');
      expect(item.name, 'B.py');
    });

    test('should be access sender [foo]', () {
      ReceiveItem item = ReceiveItem(
          iconData: Icons.image,
          name: 'B.py',
          data: Uint8List(0),
          sender: 'foo');
      expect(item.sender, 'foo');
    });

    test('should be access sender [bar]', () {
      ReceiveItem item = ReceiveItem(
          iconData: Icons.image,
          name: 'B.py',
          data: Uint8List(0),
          sender: 'bar');
      expect(item.sender, 'bar');
    });
  });
}

ReceiveItem createItem(
    {iconData = Icons.image,
    name = 'test.dart',
    data = '',
    sender = 'no name'}) {
  return ReceiveItem(
      iconData: iconData,
      name: name,
      data: Uint8List.fromList(utf8.encode(data)),
      sender: sender);
}

ReceiveItem createItemWithoutIcon(
    {name = 'test.dart', data = '', sender = 'no name'}) {
  return ReceiveItem(
      name: name, data: Uint8List.fromList(utf8.encode(data)), sender: sender);
}

void sizeTest() {
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
      ReceiveItem item = createItem(data: 'A' * 1024);
      expect(item.size, 1024);
    });

    test('should be get size string 0B when empty data', () {
      ReceiveItem item = createItem(data: '');
      expect(item.sizeStr, '0B');
    });

    test('should be get size string 1B when one char', () {
      ReceiveItem item = createItem(data: 'A');
      expect(item.sizeStr, '1B');
    });

    test('should be get size string 1KB when 1024 chars', () {
      ReceiveItem item = createItem(data: 'A' * 1024);
      expect(item.sizeStr, '1KB');
    });

    test('should be get size string 3KB when 4095 chars', () {
      ReceiveItem item = createItem(data: 'A' * 1024 * 1024);
      expect(item.sizeStr, '1MB');
    });

    test('should be get size string 3KB when 4095 chars', () {
      ReceiveItem item = createItem(data: 'AAB' * 1024 * 1024);
      expect(item.sizeStr, '3MB');
    });
  });
}

void iconTest() {
  group('set icon test', () {
    test('should be auto set icon description default', () {
      ReceiveItem item = createItemWithoutIcon(name: 'A');
      expect(item.iconData, Icons.description);
    });

    test('should be auto set icon image when suffix is [jpg]', () {
      ReceiveItem item = createItemWithoutIcon(name: 'A.jpg');
      expect(item.iconData, Icons.image);
    });
  });
}

void tempFileTest() {
  group('create temp file test', () {
    test('should be create temp file.', () async {
      createItem(name: 'temp.dart');
      await Future.delayed(
          const Duration(milliseconds: 1)); // wait to create temp file.
      expect(await File(p.join(kTempDir.path, 'temp.dart')).exists(), isTrue);
    });

    test('should be write receive content.', () async {
      createItem(name: 'temp.dart', data: 'should be write receive content.');
      await Future.delayed(
          const Duration(milliseconds: 1)); // wait to create temp file.
      File file = File(p.join(kTempDir.path, 'temp.dart'));
      expect(await file.exists(), isTrue);
      expect(await file.readAsString(), 'should be write receive content.');
    });

    test('should be get temp file path.', () async {
      ReceiveItem item = createItem(name: 'temp.dart');
      await Future.delayed(
          const Duration(milliseconds: 1)); // wait to create temp file.
      File file = File(p.join(kTempDir.path, 'temp.dart'));
      expect(item.tempPath, file.path);
    });
  });
}
