import 'dart:io';
import 'dart:typed_data';

typedef ConnectionCallback = Function(Socket socket);
typedef ReceiveCallback = Function(Socket socket, Uint8List data);

abstract class HostIF{
  Future<void> listen();
  void close();
  void send(Socket connection, Uint8List data);

}
