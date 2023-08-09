import 'package:camel/camel.dart';
import 'dart:io';
import 'package:lan_scanner/lan_scanner.dart';
import 'package:silkroad/send/entities/sendable_device.dart';

abstract class SendRepository {
  // Future<String?> connect(String connectionPoint);  // return connection's identifier
  Future send(String connectionPoint, Map<String, String> data);
  Future<List<SendableDevice>> sendable(
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
  /// 2. Send Sendable command to existed response device.
  /// 3. return existed response devices.
  @override
  Future<List<SendableDevice>> sendable(
      String subnet, int sendPort, String bindPoint) async {
    Tcp tcpReceive = Tcp();
    Camel<Socket, SocketConnectionPoint> camelReceive = Camel(tcpReceive);

    final sendableList = <SendableDevice>[];

    _listenSendableResponse(
        sendableList, camelReceive, _createConnectionPoint(bindPoint));

    final hosts = <Host>[];
    await for (final host in fetchLocalDevices(subnet)) {
      print(host.internetAddress.address);
      hosts.add(host);
      if(host.internetAddress.address == "192.168.12.155"){
        break;
      }
    }

    for(final host in hosts){
      if(host.internetAddress.address == "192.168.12.155") continue;
      final connectionPoint = SocketConnectionPoint(
          address: host.internetAddress.address, port: sendPort);
      Tcp tcpSend = Tcp();
      Camel<Socket, SocketConnectionPoint> camelSend = Camel(tcpSend);
      try{
        await camelSend.send(
          connectionPoint,
          Message.fromBody(
            body: "",
            command: "Sendable",
          ),
        ).timeout(Duration(seconds: 1));
      }
      catch(e){
        print(e);
      }

      camelSend.close();
    }

    await Future.delayed(Duration(seconds: 3));
    camelReceive.close();
    return sendableList;
  }

  Future<void> _listenSendableResponse(
      List<SendableDevice> responseList,
      Camel<Socket, SocketConnectionPoint> camel,
      SocketConnectionPoint connectionPoint) async {
    await for (final data in camel.listen(connectionPoint)) {
      responseList.add(
        SendableDevice(ipAddress: data.connection.address.address),
      );
    }
  }

  Stream<Host> fetchLocalDevices(String subnet) {
    final scanner = LanScanner();
    return scanner.icmpScan(subnet,
      scanThreads: 20,);
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
