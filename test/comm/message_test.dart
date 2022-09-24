import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:silkroad/comm/message.dart';


void main() {
  commandConvertTest();
}

Uint8List convertCommand({command=''}){
  return Uint8List.fromList(utf8.encode(command));
}


void commandConvertTest() {
  group('command convert test from message', () {
    test('should be return none command when receive empty string', () async {
      Message message = Message.convert(convertCommand(command: ''));
      expect(Command.none, message.command);
    });

    test('should be return sendfile command when receive send file string', () async {
      Message message = Message.convert(convertCommand(command: 'SEND_FILE'));
      expect(Command.sendFile, message.command);
    });
  });
}
