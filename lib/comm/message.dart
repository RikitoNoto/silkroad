import 'dart:typed_data';

import 'package:silkroad/comm/comm.dart';

enum Command{
  none,
  sendFile,
}

abstract class Message{
  const Message({required this.command});
  final Command command;

  static Map<String, Command> commandConvertTable = {
    'SEND_FILE' : Command.sendFile,
  };

  static Map<Command, Type> _commandToClassTable = {
    Command.sendFile: Message,
  };

  static Message convert(Uint8List data){
    Command command = commandConvertTable[String.fromCharCodes(data)] != null ?  commandConvertTable[String.fromCharCodes(data)]! : Command.none;
//    return Message(command: command);
    if(_commandToClassTable[command] != null){
      return _commandToClassTable[command]();
    }

    return _commandToClassTable[command]();
  }

}

class SendFile implements Message{
  @override
  Command get command => command;

  static Message build(Uint8List data){

  }
}
