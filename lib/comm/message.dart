import 'dart:convert';
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
  const Message(command);

  Command get command;

  static Map<String, Command> commandConvertTable = {
    'SEND_FILE' : Command.sendFile,
  };

  String getDataStr(int index);
  Uint8List getDataBin(int index);

  static Message convert(Uint8List data){
    String? commandStr = RegExp('^(.*)\n').firstMatch(String.fromCharCodes(data))?.group(1);

    Command command = commandConvertTable[commandStr] != null ?  commandConvertTable[commandStr]! : Command.none;

    if(_commandToClassTable[command] == null){
      return _commandToClassTable[Command.none]!(data);
    }

    return _commandToClassTable[command]!(data);
  }

}

class None implements Message{
  const None({required this.receiveData});

  @override
  Command get command => Command.none;

  final Uint8List receiveData;

  static Message construct(Uint8List data){
    return None(receiveData: data);
  }

  @override
  String getDataStr(int index) {
    throw ArgumentError("None class can't get data.");
  }

  @override
  Uint8List getDataBin(int index) {
    throw ArgumentError("None class can't get data.");
  }
}

class SendFile implements Message{
  static const int dataIndexName = 0;
  static const int dataIndexFile = 1;

  SendFile({required this.receiveData}){
    name = _fetchName(receiveData);
    fileData = _fetchFileData(receiveData);
  }

  @override
  Command get command => Command.sendFile;

  late final String name;
  late final Uint8List fileData;
  final Uint8List receiveData;

  static Message construct(Uint8List data){
    return SendFile(receiveData: data);
  }

  @override
  String getDataStr(int index) {
    return name;
  }

  @override
  Uint8List getDataBin(int index) {
    return fileData;
  }

  static String _fetchName(Uint8List data){
    String name;
    String? match = RegExp('^name:(.*)', multiLine: true).firstMatch(String.fromCharCodes(data))?.group(1);
    if(match != null){
      name = match;
    }else{
      name = '';
    }
    return name;
  }

  static Uint8List _fetchFileData(Uint8List data){
    Uint8List fileData;
    String? match = RegExp('^file:(.*)', dotAll: true, multiLine: true).firstMatch(String.fromCharCodes(data))?.group(1);

    if(match != null){
      fileData = Uint8List.fromList(utf8.encode(match));
    }else{
      fileData = Uint8List.fromList(utf8.encode(''));
    }
    return fileData;
  }
}
