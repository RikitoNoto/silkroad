import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:silkroad/comm/message.dart';


void main() {
  commandNoneTest();
  commandSendFileTest();
}

Uint8List convertCommand({command=''}){
  return Uint8List.fromList(utf8.encode(command + '\n'));
}

Uint8List convertSendFileCommand({name='', file='', sender=''}){
  return Uint8List.fromList(utf8.encode('SEND_FILE\nname:${name}\nsender:${sender}\n\n${file}'));
}

void commandNoneTest() {
  group('command none test', () {
    test('should be return none command when receive empty string', () async {
      Message message = Message(convertCommand(command: ''));
      expect(message.command, Command.none);
    });
  });
}

void commandSendFileTest() {
  group('command send file test', () {
    test('should be return sendfile command when receive send file string', () async {
      Message message = Message(convertSendFileCommand());
      expect(message.command, Command.sendFile);
    });

    test('should be return none command when receive send file string', () async {
      Message message = Message(convertSendFileCommand());
      expect(message is SendFile, isTrue);
    });
    nameSendFileTest();
    dataSendFileTest();
    senderSendFileTest();
  });
}

void senderSendFileTest(){
  group('convert sender in send file message', () {
    test('should be able to get sender [sender]', () async {
      Message message = Message(convertSendFileCommand(sender: 'sender'));
      expect(message is SendFile, isTrue);
      expect(message.getDataStr(SendFile.dataIndexSender), 'sender');
    });
  });
}

void dataSendFileTest(){
  group('convert data in send file message', () {
    test('should be able to get data I', () async {
      Message message = Message(convertSendFileCommand(file: 'I'));
      expect(message is SendFile, isTrue);
      expect(String.fromCharCodes(message.getDataBin(SendFile.dataIndexFile)), 'I');
    });

    test('should be able to get data II include new line', () async {
      Message message = Message(convertSendFileCommand(file: 'I\nI'));
      expect(message is SendFile, isTrue);
      expect(String.fromCharCodes(message.getDataBin(SendFile.dataIndexFile)), 'I\nI');
    });

    test('should be able to get data that same separator', () async {
      Message message = Message(convertSendFileCommand(file: '\n\n'));
      expect(message is SendFile, isTrue);
      expect(String.fromCharCodes(message.getDataBin(SendFile.dataIndexFile)), '\n\n');
    });
  });
}

void nameSendFileTest(){
  group('convert name in send file message', () {

    test('should be able to get empty string when send empty message', () async {
      Message message = Message(Uint8List.fromList(utf8.encode('SEND_FILE\n')));
      expect(message is SendFile, isTrue);
      expect(message.getDataStr(SendFile.dataIndexName), '');
    });

    test('should be able to get filename A', () async {
      Message message = Message(convertSendFileCommand(name: 'A'));
      expect(message is SendFile, isTrue);
      expect(message.getDataStr(SendFile.dataIndexName), 'A');
    });

    test('should be able to get filename B', () async {
      Message message = Message(convertSendFileCommand(name: 'B'));
      expect(message is SendFile, isTrue);
      expect(message.getDataStr(SendFile.dataIndexName), 'B');
    });

    test('should be able to get empty string when send empty message and include name: in file data.', () async {
      Message message = Message(Uint8List.fromList(utf8.encode('SEND_FILE\n\nname:a')));
      expect(message is SendFile, isTrue);
      expect(message.getDataStr(SendFile.dataIndexName), '');
    });

    test('should be able to get name A when include two names', () async {
      Message message = Message(convertSendFileCommand(name: 'A',file: 'name: \'B\''));
      expect(message is SendFile, isTrue);
      expect(message.getDataStr(SendFile.dataIndexName), 'A');
    });
  });
}
