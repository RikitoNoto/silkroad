import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'communication_if.dart';
import 'message.dart';


class _ReceiveData{
  _ReceiveData(Uint8List data){
    for(int i=0; i<data.length; i++){
      if(data[i] == utf8.encode('\n').first){
        size = int.parse(String.fromCharCodes(data.sublist(0, i)));
        _data = data.sublist(i+1, data.length).toList();
        break;
      }
    }
  }

  late final int size;
  late final List<int> _data;

  Uint8List get data => Uint8List.fromList(_data);

  void append(Uint8List data){
    _data.addAll(data);
  }

  bool isReceiveFin(){
    return _data.length == size;
  }
}

class Tcp implements CommunicationIF<Socket>{
  Tcp();

  final List<ServerSocket> _serverSocket = <ServerSocket>[];
  final List<Socket> _connections = <Socket>[];           // connecting socket list
  final Map<Socket, _ReceiveData> _receiveDataMap = <Socket, _ReceiveData>{};

  String? _convertAddress(String addressStr){
    RegExpMatch? match = RegExp("(([0-9]+\.)+[0-9]+):([0-9]+)").firstMatch(addressStr);
    return match?.group(1);
  }

  int? _convertPort(String portStr){
    RegExpMatch? match = RegExp("(([0-9]+\.)+[0-9]+):([0-9]+)").firstMatch(portStr);
    String? port = match?.group(3);
    return port != null ? int.parse(port) : null;
  }

  @override
  Future<Socket?> connect(String to) async{
    // RegExpMatch? match = RegExp("((\d+\.)+\d+):(\d+)").firstMatch(to);
    String? address = _convertAddress(to); // match?.group(1);
    int? port = _convertPort(to); //match?.group(3);
    if( (address != null) && (port != null) ){
      return await Socket.connect(address, port);
    }
    else{
      throw ArgumentError('invalid arg [$to].\nthe arg format is <address>:<port>');
    }
  }
  
  @override
  Future<void> listen(String bind, {ConnectionCallback<Socket>? connectionCallback, ReceiveCallback<Socket>? receiveCallback}) async{
    if( (_convertAddress(bind) == null) || (_convertPort(bind) == null )) throw ArgumentError('invalid arg. the arg format is <address>:<port>');

    ServerSocket socket;
    try{
      socket = await ServerSocket.bind(_convertAddress(bind), _convertPort(bind)!);
      _serverSocket.add(socket);
    }catch(e){
      if(kDebugMode) {
        print("fail binding");
      }
      return ;
    }

    if(kDebugMode) {
      print("begin listen port");
    }
    socket.listen(
      (connection) {
        _connections.add(connection);
        if(connectionCallback != null){
          connectionCallback(connection);
        }

        _listenConnection(connection, receiveCallback: receiveCallback);
      }
    );

    return ;
  }

  @override
  Future close() async{
    _connections.forEach((connection) async {
      await connection.close();
    });

    _serverSocket.forEach((connection) async {
      await connection.close();
    });
    _connections.clear();
    _serverSocket.clear();
  }

  @override
  Future<Result> send(Socket connection, Message data) async {
    connection.write('${utf8.encode(data.data).length}\n${data.data}');
    // connection.write(data.data);
    return Future.value(Result.success);
  }

  Future<void> _listenConnection(Socket connection, {ReceiveCallback<Socket>? receiveCallback}){
    connection.listen(
      (Uint8List data) {
        if(kDebugMode) {
          print('receive: size[${data.length}]');
          print(String.fromCharCodes(data));
        }

        if(!_receiveDataMap.containsKey(connection)) {

          _receiveDataMap[connection] = _ReceiveData(data);
        }
        else {
          _ReceiveData receiveData = _receiveDataMap[connection]!;
          receiveData.append(data);
        }


        // if receive all data.
        if(_receiveDataMap[connection]!.isReceiveFin()){
          if(receiveCallback != null){
            receiveCallback(connection, Message(_receiveDataMap[connection]!.data));
          }

          _receiveDataMap.remove(connection);
        }
      },
    );
    return Future(()=>{});
  }
}
