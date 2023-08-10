import 'dart:isolate';

import 'package:camel/camel.dart';
import 'dart:io';
import 'package:lan_scanner/lan_scanner.dart';
import 'package:silkroad/send/entities/sendible_device.dart';

abstract class SendRepository {
  // Future<String?> connect(String connectionPoint);  // return connection's identifier
  Future send(String connectionPoint, Map<String, String> data);
  Future<List<SendibleDevice>> sendible(
      String subnet, int sendPort, String bindPoint);
  void close();
}

class SendRepositoryCamel implements SendRepository {
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
  Future send(String connectionPoint, Map<String, String> data) async {
    Tcp tcpSend = Tcp();
    Camel<Socket, SocketConnectionPoint> camelSend = Camel(tcpSend);

    String? address = _convertAddress(connectionPoint);
    int? port = _convertPort(connectionPoint);
    if ((address == null) || (port == null)) {
      throw ArgumentError(
          "invalid address format.\n expect <address>:<port>, but $connectionPoint");
    }

    await camelSend.send(
        SocketConnectionPoint(address: address, port: port),
        Message.fromBody(
          body: '${data["title"]}\n'
              '${data["data"]}\n',
          command: "SendFile",
        ));

    camelSend.close();
  }

  /// 1. Send Ping to all of same network device.
  /// 2. Send Sendible command to existed response device.
  /// 3. return existed response devices.
  @override
  Future<List<SendibleDevice>> sendible(
      String subnet, int sendPort, String bindPoint,
      {timeout = const Duration(seconds: 3)}) async {
    Tcp tcpReceive = Tcp();
    Camel<Socket, SocketConnectionPoint> camelReceive = Camel(tcpReceive);

    final sendibleList = <SendibleDevice>[];

    _listenSendibleResponse(
        sendibleList, camelReceive, _createConnectionPoint(bindPoint));

    await for (final host in fetchLocalDevices(subnet)) {
      Isolate.spawn(_sendSendibleCommand, [
        host.internetAddress.address,
        sendPort,
        const Duration(seconds: 1),
      ]);
    }

    await Future.delayed(timeout);
    camelReceive.close();
    return sendibleList;
  }

  /// Send a Sendible command for receives the response.
  /// This method should be called as other process.
  /// because it kill itself finally.
  void _sendSendibleCommand(List<Object> args) async {
    final ipAddress = args[0] as String;
    final port = args[1] as int;
    final timeout = args[2] as Duration;

    final connectionPoint =
        SocketConnectionPoint(address: ipAddress, port: port);
    Tcp tcpSend = Tcp();
    Camel<Socket, SocketConnectionPoint> camelSend = Camel(tcpSend);
    try {
      await camelSend
          .send(
            connectionPoint,
            Message.fromBody(
              body: "",
              command: "Sendible",
            ),
          )
          .timeout(timeout);
    } catch (e) {
      // time out or connection failed
    }

    camelSend.close();
    Isolate.exit(); // kill the process itself.
  }

  Future<void> _listenSendibleResponse(
      List<SendibleDevice> responseList,
      Camel<Socket, SocketConnectionPoint> camel,
      SocketConnectionPoint connectionPoint) async {
    await for (final data in camel.listen(connectionPoint)) {
      responseList.add(
        SendibleDevice(ipAddress: data.connection.address.address),
      );
    }
  }

  Stream<Host> fetchLocalDevices(String subnet) {
    final scanner = LanScanner();
    return scanner.icmpScan(
      subnet,
      scanThreads: 20,
    );
  }

  SocketConnectionPoint _createConnectionPoint(String connectionPoint) {
    String? address = _convertAddress(connectionPoint);
    int? port = _convertPort(connectionPoint);
    if ((address == null) || (port == null)) {
      throw ArgumentError(
          "invalid address format.\n expect <address>:<port>, but $connectionPoint");
    }

    return SocketConnectionPoint(address: address, port: port);
  }

  @override
  void close() {}
}
