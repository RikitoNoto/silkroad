import 'package:camel/camel.dart';
import 'dart:io';

abstract class SendRepository {
  // Future<String?> connect(String connectionPoint);  // return connection's identifier
  Future send(String connectionPoint, Map<String, String> data);
  void close();
}

class SendRepositoryCamel implements SendRepository{

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
  Future send(String connectionPoint, Map<String, String> data) async {
    Tcp tcpSend = Tcp();
    Camel<Socket, SocketConnectionPoint> camelSend = Camel(tcpSend);

    String? address = _convertAddress(connectionPoint);
    int? port = _convertPort(connectionPoint);
    if((address == null) || (port == null)) {
      throw ArgumentError("invalid address format.\n expect <address>:<port>, but $connectionPoint");
    }

    await camelSend.send(
        SocketConnectionPoint(address: address, port: port),
        Message.fromBody(body:
          '${data["title"]}\n'
          '${data["data"]}\n'
        )
    );

    camelSend.close();
  }

  @override
  void close(){

  }
}
