import 'dart:io';
import 'package:flutter/foundation.dart';

import 'communication_if.dart';


class Tcp implements CommunicationIF<Socket>{
  Tcp({
    required this.ipAddress,
    required this.port,
    this.connectionCallback,
    this.receiveCallback,
  });

  final String ipAddress;
  final int port; 
  final ConnectionCallback<Socket>? connectionCallback; // callback when connection socket.
  final ReceiveCallback<Socket>? receiveCallback;       // callback when receive message.
  ServerSocket? _server_socket;
  List<Socket> _connections = <Socket>[];           // connecting socket list

  @override
  Future<void> listen() async{

    try{
      _server_socket = await ServerSocket.bind(ipAddress, port);
    }catch(e){
      if(kDebugMode) {
        print("fail binding");
      }
      return ;
    }

    if(kDebugMode) {
      print("begin listen port");
    }
    _server_socket?.listen(
      (connection) {
        _connections.add(connection);
        if(connectionCallback != null){
          connectionCallback!(connection);
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
    _server_socket?.close();

    _connections.clear();
    _server_socket = null;
  }

  @override
  Future<Result> send(Socket connection, Uint8List data) async {
    connection.write(data);
    return Future.value(Result.success);
  }

  Future<void> _listenConnection(Socket connection){
    connection.listen(
      (Uint8List data) {
        if(kDebugMode) {
          print(String.fromCharCodes(data));
        }

        if(receiveCallback != null){
          receiveCallback!(connection, data);
        }
      }
    );
    return Future(()=>{});
  }
}
