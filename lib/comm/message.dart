import 'dart:typed_data';

import 'package:silkroad/comm/comm.dart';

enum Command{
  none,
  sendFile,
}

typedef _MessageFactoryMethod = Message Function(Uint8List data);
Map<Command, _MessageFactoryMethod> _commandToClassTable = {
  Command.none    : None.construct,
  Command.sendFile: SendFile.construct,
};

abstract class Message{
  const Message({required this.command});

  final Command command;

  static Map<String, Command> commandConvertTable = {
    'SEND_FILE' : Command.sendFile,
  };

  static Message convert(Uint8List data){
    Command command = commandConvertTable[String.fromCharCodes(data)] != null ?  commandConvertTable[String.fromCharCodes(data)]! : Command.none;
//    return Message(command: command);

    if(_commandToClassTable[command] == null){
      return _commandToClassTable[Command.none]!(data);
    }

    return _commandToClassTable[command]!(data);
  }

}

class None implements Message{
  const None({required this.receiveData}) : this.command = Command.none;

  @override
  final Command command;

  final Uint8List receiveData;

  static Message construct(Uint8List data){
    return None(receiveData: data);
  }
}

class SendFile implements Message{
  SendFile({required this.receiveData}) : this.command = Command.sendFile
  {

  }

  @override
  final Command command;

  final Uint8List receiveData;

  static Message construct(Uint8List data){
    return SendFile(receiveData: data);
  }
}
