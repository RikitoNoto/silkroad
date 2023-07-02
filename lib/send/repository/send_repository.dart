import 'dart:typed_data';

abstract class SendRepository {
  Future<String> connect(String connectionPoint);  // return connection's identifier
  Future send(Uint8List data);
  void close();
}
