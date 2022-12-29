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
    String? commandStr = RegExp('^(.*)\n').firstMatch(utf8.decode(data))?.group(1);

    Command command = _commandConvertTable[commandStr] != null ?  _commandConvertTable[commandStr]! : Command.none;

    if(_commandToClassTable[command] == null){
      return _commandToClassTable[Command.none]!(data);
    }

    return _commandToClassTable[command]!(data);
  }

  String get data;
  Command get command;

  static final Map<String, Command> _commandConvertTable = {
    'SEND_FILE' : Command.sendFile,
  };

  static String? convertMessageString(Command from){
    String? messageStr;
    _commandConvertTable.forEach((key, value) {
      if(value == from) messageStr ??= key;
    });
    return messageStr;
  }

  String getDataStr(int index);
  Uint8List getDataBin(int index);

}

class None implements Message{
  const None({required this.receiveData});

  @override
  Command get command => Command.none;

  @override
  String get data => '';

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
  static const int dataIndexSender = 2;

  SendFile.receive({required receiveData}){
    RegExpMatch? dataSplitter = RegExp('(.*?)^\n(.*)', dotAll: true, multiLine: true).firstMatch(utf8.decode(receiveData));
    String header = dataSplitter?.group(1) ?? '';
    List<int>? dataList;
    if(dataSplitter?.group(2) != ''){
      dataList = dataSplitter?.group(2)?.split(',').map<int>((String item)=>int.parse(item)).toList();
    }
    fileData = dataList!=null ? Uint8List.fromList(dataList) : Uint8List(0);
    name = _fetchName(header);
    sender = _fetchSender(header);
  }

  SendFile.send({required this.name, required this.sender, required this.fileData,});

  @override
  Command get command => Command.sendFile;

  @override
  String get data {
    return
      '${Message.convertMessageString(command)}\n'  // command
      'name:$name\n'                                // file name
      'sender:$sender\n'                            // sender
      '\n'                                          // separator
      '${fileData.map<String>((int value) => value.toString()).join(',')}'           // file data
      ;
  }

  late final String name;
  late final String sender;
  late final Uint8List fileData;

  static Message construct(Uint8List data){
    return SendFile.receive(receiveData: data);
  }

  @override
  String getDataStr(int index) {
    String data = '';
    switch(index){
      case dataIndexName:
        data = name;
        break;
      case dataIndexFile:
        data = String.fromCharCodes(fileData);
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
    String? match = RegExp('^$sectionName:(.*)', multiLine: true).firstMatch(data)?.group(1);
    return match ?? '';
  }
}
