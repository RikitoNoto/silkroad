import 'dart:io';
import 'dart:typed_data';

typedef ConnectionCallback = Function(Socket socket);
typedef ReceiveCallback = Function(Socket socket, Uint8List data);

class TcpHost{
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

  Future<void> listen() async{

    try{
      _server_socket = await ServerSocket.bind(ipAddress, port);
    }catch(e){
      print(e);
      throw Exception('open error!!');
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

    return Future(()=>{});
  }

  void close(){
    _connections.forEach((connection) {
      connection.close();
    });
    _server_socket?.close();
  }

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
