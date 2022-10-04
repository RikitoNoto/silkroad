import 'dart:io';
import 'dart:typed_data';
import 'host_if.dart';


class TcpHost implements HostIF{
  TcpHost({
    required this.ipAddress,
    required this.port,
    this.connectionCallback,
    this.receiveCallback,
  });

  final String ipAddress;
  final int port; 
  final ConnectionCallback? connectionCallback; // callback when connection socket.
  final ReceiveCallback? receiveCallback;       // callback when receive message.
  ServerSocket? _server_socket;
  List<Socket> _connections = <Socket>[];           // connecting socket list

  @override
  Future<void> listen() async{

    try{
      _server_socket = await ServerSocket.bind(ipAddress, port);
    }catch(e){
      print(e);
      throw Exception('open error!!');
    }

    print("begin listen port");
    _server_socket?.listen(
      (connection) {
        _connections.add(connection);
        if(connectionCallback != null){
          connectionCallback!(connection);
        }

        _listenConnection(connection);
      }
    );

    return Future(()=>{});
  }

  @override
  void close(){
    _connections.forEach((connection) {
      connection.close();
    });
    _server_socket?.close();

    _connections.clear();
    _server_socket = null;
  }

  @override
  void send(Socket connection, Uint8List data){
    connection.write(data);
  }

  Future<void> _listenConnection(Socket connection){
    connection.listen(
            (Uint8List data) {
          if(receiveCallback != null){
            receiveCallback!(connection, data);
          }
        }
    );
    return Future(()=>{});
  }
}
