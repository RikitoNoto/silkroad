import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:silkroad/comm/message.dart';


void main() {
  commandNoneTest();
  commandSendFileTest();
  convertMessageTest();
  convertMessageFromSendMessageTest();
}

Uint8List convertCommand({command=''}){
  return Uint8List.fromList(utf8.encode(command + '\n'));
}

Uint8List convertSendFileCommand({name='', sender=''}){ //, file=''}){
  return Uint8List.fromList(utf8.encode('SEND_FILE\nname:$name\nsender:$sender\n\n'));//$file'));
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
    test('should be return send file command when receive send file string', () async {
      Message message = Message(convertSendFileCommand());
      expect(message.command, Command.sendFile);
    });

    test('should be return none command when receive send file string', () async {
      Message message = Message(convertSendFileCommand());
      expect(message is SendFile, isTrue);
    });
    nameSendFileTest();
//    dataSendFileTest();
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

//void dataSendFileTest(){
//  group('convert data in send file message', () {
//    test('should be able to get data I', () async {
//      Message message = Message(convertSendFileCommand(file: 'I'));
//      expect(message is SendFile, isTrue);
//      expect(String.fromCharCodes(message.getDataBin(SendFile.dataIndexFile)), 'I');
//    });
//
//    test('should be able to get data II include new line', () async {
//      Message message = Message(convertSendFileCommand(file: 'I\nI'));
//      expect(message is SendFile, isTrue);
//      expect(String.fromCharCodes(message.getDataBin(SendFile.dataIndexFile)), 'I\nI');
//    });
//
//    test('should be able to get data that same separator', () async {
//      Message message = Message(convertSendFileCommand(file: '\n\n'));
//      expect(message is SendFile, isTrue);
//      expect(String.fromCharCodes(message.getDataBin(SendFile.dataIndexFile)), '\n\n');
//    });
//
//    test('should be able to get data as string', () async {
//      Message message = Message(convertSendFileCommand(file: 'AAA'));
//      expect(message is SendFile, isTrue);
//      expect(message.getDataStr(SendFile.dataIndexFile), 'AAA');
//    });
//  });
//}

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

//    test('should be able to get empty string when send empty message and include name: in file data.', () async {
//      Message message = Message(Uint8List.fromList(utf8.encode('SEND_FILE\n\nname:a')));
//      expect(message is SendFile, isTrue);
//      expect(message.getDataStr(SendFile.dataIndexName), '');
//    });

//    test('should be able to get name A when include two names', () async {
//      Message message = Message(convertSendFileCommand(name: 'A',file: 'name: \'B\''));
//      expect(message is SendFile, isTrue);
//      expect(message.getDataStr(SendFile.dataIndexName), 'A');
//    });
  });
}

void convertMessageTest(){
  group('command convert to byte message test', () {
    test('should be get send data1', (){
      Message message = SendFile.send(name: 'file name', sender: 'sender', fileData: Uint8List(0),);
      expect(message.data, 'SEND_FILE\nname:file name\nsender:sender\n\n');
    });

//    test('should be get send data2', (){
//      Message message = SendFile.send(name: '_file_name_', sender: '_sender_', fileData: Uint8List.fromList(utf8.encode('aaabbb')),);
//      expect(message.data, 'SEND_FILE\nname:_file_name_\nsender:_sender_\n\n${'aaabbb'}');
//    });
//
//    test('should be get send data with binary', (){
//      Message message = SendFile.send(name: 'file_name', sender: '_sender', fileData: Uint8List.fromList([0x00, 0x10, 0x54, 0x00]),);
//      expect(message.data, 'SEND_FILE\nname:file_name\nsender:_sender\n\n${String.fromCharCodes([0x00, 0x10, 0x54, 0x00])}');
//    });
  });
}


void convertMessageFromSendMessageTest(){
  group('create message from SendFile message test', (){
    test('should be create Message from SendFile message', () {
      Message message = SendFile.send(name: '', sender: '', fileData: Uint8List(0));
      Message receive = Message(Uint8List.fromList(utf8.encode(message.data)));
      expect(receive is SendFile, isTrue);
      expect(receive.getDataStr(SendFile.dataIndexName), '');
      expect(receive.getDataStr(SendFile.dataIndexSender), '');
      expect(receive.getDataBin(SendFile.dataIndexFile).length, 0);
//      Uint8List receiveFileData = receive.getDataBin(SendFile.dataIndexFile);
//      for(int i=0; i<data.length; i++){
//        expect(receiveFileData[i], data[i]);
//      }
    });

    test('should be create Message from SendFile message with 1byte data[0x00]', () {
      Message message = SendFile.send(name: '', sender: '', fileData: Uint8List.fromList([0x00]));
      Message receive = Message(Uint8List.fromList(utf8.encode(message.data)));
      expect(receive is SendFile, isTrue);
      expect(receive.getDataStr(SendFile.dataIndexName), '');
      expect(receive.getDataStr(SendFile.dataIndexSender), '');
      expect(receive.getDataBin(SendFile.dataIndexFile).length, 1);
      expect(receive.getDataBin(SendFile.dataIndexFile)[0], 0x00);
    });


    test('should be create Message from SendFile message with 1byte data[0xFF]', () {
      Message message = SendFile.send(name: '', sender: '', fileData: Uint8List.fromList([0xFF]));
      Message receive = Message(Uint8List.fromList(utf8.encode(message.data)));
      expect(receive is SendFile, isTrue);
      expect(receive.getDataStr(SendFile.dataIndexName), '');
      expect(receive.getDataStr(SendFile.dataIndexSender), '');
      expect(receive.getDataBin(SendFile.dataIndexFile).length, 1);
      expect(receive.getDataBin(SendFile.dataIndexFile)[0], 0xFF);
    });
  });
}
