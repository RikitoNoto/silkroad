import 'dart:typed_data';

import 'package:silkroad/receive/entity/receive_item.dart';
import 'package:camel/camel.dart';
import 'dart:io';

abstract class ReceiveRepository {
  Stream<ReceiveItem> listen(String connectionPoint);
  void close();
}

class ReceiveRepositoryCamel implements ReceiveRepository {
  Camel<Socket, SocketConnectionPoint>? _receiver;

  String? _convertAddress(String addressStr) {
    RegExpMatch? match =
        RegExp("(([0-9]+\.)+[0-9]+):([0-9]+)").firstMatch(addressStr);
    return match?.group(1);
  }

  int? _convertPort(String portStr) {
    RegExpMatch? match =
        RegExp("(([0-9]+\.)+[0-9]+):([0-9]+)").firstMatch(portStr);
    String? port = match?.group(3);
    return port != null ? int.parse(port) : null;
  }

  @override
  Stream<ReceiveItem> listen(String connectionPoint) {
    String? address = _convertAddress(connectionPoint);
    int? port = _convertPort(connectionPoint);
    if ((address == null) || (port == null)) {
      throw ArgumentError(
          "invalid address format.\n expect <address>:<port>, but $connectionPoint");
    }

    return _listen(address, port);
  }

  Stream<ReceiveItem> _listen(String address, int port) async* {
    Tcp tcpReceive = Tcp();
    Camel<Socket, SocketConnectionPoint> receiver = Camel(tcpReceive);
    _receiver = receiver;

    await for (CommunicateData<Socket> data in receiver
        .listen(SocketConnectionPoint(address: address, port: port))) {
      String command = data.message.header.command;

      switch (command) {
        case "SendFile":
          String body = data.message.body;
          final item = _analyzeSendFileCommand(body);
          if (item != null) {
            yield item;
          }
          break;

        case "Sendable":
          receiver.send(
              SocketConnectionPoint(
                  address: data.connection.address.address, port: port),
              Message.fromBody(body: ""));
          break;
      }
    }
  }

  ReceiveItem? _analyzeSendFileCommand(String body) {
    RegExpMatch? match = RegExp("(.*)\n(.*)").firstMatch(body);
    String dataString = match?.group(2) ?? "";
    List<int> dataList = dataString
        .split(',')
        .map<int>((String item) => int.parse(item))
        .toList();
    if (match != null) {
      return ReceiveItem(
          name: match.group(1) ?? "",
          data: Uint8List.fromList(dataList),
          sender: "");
    }

    return null;
  }

  @override
  void close() {
    _receiver?.close();
  }
}
