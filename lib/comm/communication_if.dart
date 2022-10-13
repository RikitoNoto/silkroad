import 'dart:typed_data';

typedef ConnectionCallback<T> = Function(T socket);
typedef ReceiveCallback<T> = Function(T socket, Uint8List data);

enum Result{
  success,
  fail,
}

abstract class CommunicationIF<T>{
  Future<T?> connect(String to);
  Future<void> listen(String bind, {ConnectionCallback<T>? connectionCallback, ReceiveCallback<T>? receiveCallback});
  Future close();
  Future<Result> send(T connection, Uint8List data);
}
