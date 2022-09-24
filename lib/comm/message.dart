import 'dart:typed_data';

import 'package:silkroad/comm/comm.dart';

enum Command{
  none,
  sendFile,
}

class Message{
  const Message({required this.command});
  final Command command;

  static Map<String, Command> convertTable = {
    'SEND_FILE' : Command.sendFile,
  };

  static Message convert(Uint8List data){
    Command command = convertTable[String.fromCharCodes(data)] != null ?  convertTable[String.fromCharCodes(data)]! : Command.none;
    return Message(command: command);
  }
}
