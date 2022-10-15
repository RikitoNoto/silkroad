import 'dart:typed_data';
import 'message.dart';

typedef ConnectionCallback<T> = Function(T socket);
typedef ReceiveCallback<T> = Function(T socket, Uint8List data);//TODO: change the type of data to Message

enum Result{
  success,
  fail,
}

abstract class CommunicationIF<T>{
  Future<T?> connect(String to);
  Future<void> listen(String bind, {ConnectionCallback<T>? connectionCallback, ReceiveCallback<T>? receiveCallback});
  Future close();
  Future<Result> send(T connection, Message data);
}
