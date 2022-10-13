import 'dart:io';
import 'package:flutter/foundation.dart';

import 'communication_if.dart';


class Tcp implements CommunicationIF<Socket>{
  Tcp();

  // final String ipAddress;
  // final int port;
  // final ConnectionCallback<Socket>? connectionCallback; // callback when connection socket.
  // final ReceiveCallback<Socket>? receiveCallback;       // callback when receive message.
  final List<ServerSocket> _serverSocket = <ServerSocket>[];
  final List<Socket> _connections = <Socket>[];           // connecting socket list

  String? _convertAddress(String addressStr){
    RegExpMatch? match = RegExp("(\d+\.)+:(\d+)").firstMatch(addressStr);
    return match?.group(1);
  }

  int? _convertPort(String portStr){
    RegExpMatch? match = RegExp("(\d+\.)+:(\d+)").firstMatch(portStr);
    String? port = match?.group(2);
    return port == null ? int.parse(port!) : null;
  }

  @override
  Future<Socket?> connect(String to) async{
    RegExpMatch? match = RegExp("(\d+\.)+:(\d+)").firstMatch(to);
    String? address = match?.group(1);
    String? port = match?.group(2);
    if( (address != null) && (port != null) ){
      return await Socket.connect(address, int.parse(port));
    }
    else{
      throw ArgumentError('invalid arg. the arg format is <address>:<port>');
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

        _listenConnection(connection);
      }
    );

    return ;
  }

  @override
  Future close() async{
    _connections.forEach((connection) {
      connection.close();
    });

    _serverSocket.forEach((connection) {
      connection.close();
    });
    _connections.clear();
    _serverSocket.clear();
  }

  @override
  Future<Result> send(Socket connection, Uint8List data) async {
    connection.write(data);
    return Future.value(Result.success);
  }

  Future<void> _listenConnection(Socket connection, {ReceiveCallback<Socket>? receiveCallback}){
    connection.listen(
      (Uint8List data) {
        if(kDebugMode) {
          print(String.fromCharCodes(data));
        }

        if(receiveCallback != null){
          receiveCallback(connection, data);
        }
      }
    );
    return Future(()=>{});
  }
}
