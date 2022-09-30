import 'dart:convert';
import 'dart:typed_data';

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
  factory Message(Uint8List data){
    String? commandStr = RegExp('^(.*)\n').firstMatch(String.fromCharCodes(data))?.group(1);

    Command command = commandConvertTable[commandStr] != null ?  commandConvertTable[commandStr]! : Command.none;

    if(_commandToClassTable[command] == null){
      return _commandToClassTable[Command.none]!(data);
    }

    return _commandToClassTable[command]!(data);
  }

  Command get command;

  static Map<String, Command> commandConvertTable = {
    'SEND_FILE' : Command.sendFile,
  };

  String getDataStr(int index);
  Uint8List getDataBin(int index);

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
  static const int dataIndexSender = 1;

  SendFile({required this.receiveData}){
    RegExpMatch? dataSplitter = RegExp('(.*?)^\n(.*)', dotAll: true, multiLine: true).firstMatch(String.fromCharCodes(receiveData));
    String header = dataSplitter?.group(1) ?? '';
    fileData = Uint8List.fromList(utf8.encode(dataSplitter?.group(2) ?? ''));
    name = _fetchName(header);
    sender = _fetchSender(header);
  }

  @override
  Command get command => Command.sendFile;

  late final String name;
  late final String sender;
  late final Uint8List fileData;
  final Uint8List receiveData;

  static Message construct(Uint8List data){
    return SendFile(receiveData: data);
  }

  @override
  String getDataStr(int index) {
    String data = '';
    switch(index){
      case dataIndexName:
        data = name;
        break;
      case dataIndexSender:
        data = sender;
        break;
    }
    return data;
  }

  @override
  Uint8List getDataBin(int index) {
    return fileData;
  }

  static String _fetchName(String data){
    return _fetchSectionValue(data, 'name');
  }

  static String _fetchSender(String data){
    return _fetchSectionValue(data, 'sender');
  }

  static String _fetchSectionValue(String data, String sectionName){
    String? match = RegExp('^${sectionName}:(.*)', multiLine: true).firstMatch(data)?.group(1);
    return match ?? '';
  }
}
