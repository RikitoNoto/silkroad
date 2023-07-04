import 'dart:typed_data';

abstract class SendRepository {
  Future<String?> connect(String connectionPoint);  // return connection's identifier
  Future send(String dest, Map<String, String> data);
  void close();
}
