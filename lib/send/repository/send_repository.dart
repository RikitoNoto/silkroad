import 'dart:async';
import 'dart:isolate';

import 'package:camel/camel.dart';
import 'dart:io';
import 'package:lan_scanner/lan_scanner.dart';
import 'package:silkroad/send/entities/sendible_device.dart';

abstract class SendRepository {
  Future send(String connectionPoint, Map<String, String> data);
  Stream<SendibleDevice> seachDevices(
    String subnet,
    int sendPort,
    String bindPoint, {
    timeout = const Duration(seconds: 3),
    void Function(double)? progressCallback,
  });
  void close();
}

class SendRepositoryCamel implements SendRepository {
  Isolate? _icpmScanIsolate;
  Camel<Socket, SocketConnectionPoint>? _receiveSocket;

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
  Stream<SendibleDevice> seachDevices(
    String subnet,
    int sendPort,
    String bindPoint, {
    timeout = const Duration(seconds: 3),
    void Function(double)? progressCallback,
  }) async* {
    Tcp tcpReceive = Tcp();
    _receiveSocket = Camel(tcpReceive);

    final sendibleList = <SendibleDevice>[];
    final bind = _createConnectionPoint(bindPoint);
    // create the port to receive the message from devices.
    _listenSendibleResponse(_receiveSocket!, bind).listen((device) {
      sendibleList.add(device);
    });

    double progress = 0.0;

    // create icpm scan process.
    final receivePort = ReceivePort();
    _icpmScanIsolate = await Isolate.spawn(_isolateIcmpScan, [
      receivePort.sendPort,
      sendPort,
      subnet,
      bind.address,
    ]);

    receivePort.listen((message) {
      progress = message;
      progressCallback?.call(progress * 0.98);
    });

    // on Android, it do not end [await for] loop.
    // because do polling.
    while (progress < 1.0) {
      if (sendibleList.isNotEmpty) {
        yield sendibleList.first;
        sendibleList.removeAt(0);
      }
      await Future.delayed(const Duration(microseconds: 1));
    }

    await Future.delayed(timeout);
    close();
    progressCallback?.call(1); // call the callback as 100%
    for (final device in sendibleList) {
      yield device;
    }
  }

  void _isolateIcmpScan(List<Object> args) async {
    final sendPipe = args[0] as SendPort;
    final sendPort = args[1] as int;
    final subnet = args[2] as String;
    final myAddress = args[3] as String;

    await for (final host
        in fetchLocalDevices(subnet, progressCallback: (progress) {
      sendPipe.send(progress);
    })) {
      if (host.internetAddress.address == myAddress) {
        continue;
      }

      Isolate.spawn(_sendSendibleCommand, [
        host.internetAddress.address,
        sendPort,
        const Duration(seconds: 1),
      ]);
    }
    Isolate.exit();
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

  Stream<SendibleDevice> _listenSendibleResponse(
      Camel<Socket, SocketConnectionPoint> camel,
      SocketConnectionPoint connectionPoint) async* {
    await for (final data in camel.listen(connectionPoint)) {
      yield SendibleDevice(ipAddress: data.connection.remoteAddress.address);
    }
  }

  Stream<Host> fetchLocalDevices(
    String subnet, {
    void Function(double)? progressCallback,
  }) {
    final scanner = LanScanner();
    return scanner.icmpScan(
      subnet,
      scanThreads: 20,
      progressCallback: progressCallback,
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
  void close() {
    _icpmScanIsolate?.kill();
    _receiveSocket?.close();
    _icpmScanIsolate = null;
    _receiveSocket = null;
  }
}
