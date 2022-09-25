import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:silkroad/comm/message.dart';


void main() {
  commandConvertTest();
}

Uint8List convertCommand({command=''}){
  return Uint8List.fromList(utf8.encode(command + '\n'));
}

Uint8List convertSendFileCommand({name='', file=''}){
  return Uint8List.fromList(utf8.encode('SEND_FILE\nname:${name}\nfile:${file}'));
}


void commandConvertTest() {
  group('command convert test from message', () {
    test('should be return none command when receive empty string', () async {
      Message message = Message.convert(convertCommand(command: ''));
      expect(message.command, Command.none);
    });

    test('should be return sendfile command when receive send file string', () async {
      Message message = Message.convert(convertSendFileCommand());
      expect(message.command, Command.sendFile);
    });

    test('should be return none command when receive send file string', () async {
      Message message = Message.convert(convertSendFileCommand());
      expect(message is SendFile, isTrue);
    });

    test('should be able to get filename A', () async {
      Message message = Message.convert(convertSendFileCommand(name: 'A'));
      expect(message is SendFile, isTrue);
      expect(message.getDataStr(SendFile.dataIndexName), 'A');
    });

    test('should be able to get filename B', () async {
      Message message = Message.convert(convertSendFileCommand(name: 'B'));
      expect(message is SendFile, isTrue);
      expect(message.getDataStr(SendFile.dataIndexName), 'B');
    });

    test('should be able to get data I', () async {
      Message message = Message.convert(convertSendFileCommand(file: 'I'));
      expect(message is SendFile, isTrue);
      expect(String.fromCharCodes(message.getDataBin(SendFile.dataIndexFile)), 'I');
    });

    test('should be able to get data II include new line', () async {
      Message message = Message.convert(convertSendFileCommand(file: 'I\nI'));
      expect(message is SendFile, isTrue);
      expect(String.fromCharCodes(message.getDataBin(SendFile.dataIndexFile)), 'I\nI');
    });

    test('should be able to get name A when include two names', () async {
      Message message = Message.convert(convertSendFileCommand(name: 'A',file: 'name: \'B\''));
      expect(message is SendFile, isTrue);
      expect(message.getDataStr(SendFile.dataIndexName), 'A');
    });
  });
}
