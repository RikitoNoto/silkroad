// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.


import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_info_plus/network_info_plus.dart';

import 'package:silkroad/comm/host_if.dart';
import 'package:silkroad/comm/tcp_host.dart';
import 'package:silkroad/receive/providers/receive_provider.dart';
import 'receive_providers_test.mocks.dart';


@GenerateMocks([NetworkInfo])
@GenerateMocks([TcpHost])
@GenerateMocks([Socket])
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MockNetworkInfo networkInfoMock = MockNetworkInfo();;
  MockTcpHost mockHost = MockTcpHost();
  MockSocket mockSocket = MockSocket();

  ipAddressTest(networkInfoMock);
  portTest(networkInfoMock, mockHost);
  callbackActionTest(networkInfoMock, mockHost, mockSocket);
}

void checkIpAddress(MockNetworkInfo mock, String? returnValue, String expectAddress) async {
  when(mock.getWifiIP()).thenAnswer((_)=>Future<String?>.value(returnValue));
  ReceiveProvider provider = ReceiveProvider();
  await mock.getWifiIP();      // for wait complete.
  expect(provider.ipAddress, expectAddress);
}

void ipAddressTest(MockNetworkInfo networkInfoMock) {

  ReceiveProvider.networkInfo = networkInfoMock;

  group('receive provider ip fetch test', () {

    test('should be get the ip address when initialize(0.0.0.0)', () {
      checkIpAddress(networkInfoMock, "0.0.0.0", "0.0.0.0");
    });

    test('should be get the ip address when initialize(255.255.255.255)', () async {
      checkIpAddress(networkInfoMock, "255.255.255.255", "255.255.255.255");
    });

    test('should be get empty string when did not get ip address', () async {
      checkIpAddress(networkInfoMock, null, "");
    });
  });
}

ReceiveProvider? provider;
String? ipAddressSpy;
ReceiveCallback? receiveCallbackSpy;
int portSpy = 0;
void setupSpyComm(MockTcpHost mockHost){
  ipAddressSpy = null;
  portSpy = 0;
  receiveCallbackSpy = null;

  provider = ReceiveProvider(builder: ({
    required String ipAddress,
    required int port,
    ConnectionCallback? connectionCallback,
    ReceiveCallback? receiveCallback}){
    ipAddressSpy = ipAddress;
    portSpy = port;
    receiveCallbackSpy = receiveCallback;
    return mockHost;
  });
}

Future<bool> openPort(String? ip, int port, MockNetworkInfo networkInfoMock){
  when(networkInfoMock.getWifiIP()).thenAnswer((_)=>Future<String?>.value(ip));
  return provider!.open();
}

Future<void> checkOpenPort(String? ip, int port, bool retval, bool isCalled, MockNetworkInfo networkInfoMock, MockTcpHost mockHost) async{

  when(mockHost.listen()).thenAnswer((_)=>Future<void>.value(()=>{}));
  verifyNever(mockHost.listen());
  bool result = await openPort(ip, port, networkInfoMock);
  if(isCalled) {
    verify(mockHost.listen());
  }else{
    verifyNever(mockHost.listen());
  }

  expect(ipAddressSpy, ip);
  expect(portSpy, port);
  expect(result, retval);
}

void portTest(MockNetworkInfo networkInfoMock, MockTcpHost mockHost) {
  group('port open and close test', () {
    ReceiveProvider.networkInfo = networkInfoMock;

    test('should be open port when call the open method', () async{
      setupSpyComm(mockHost);
      await checkOpenPort("192.168.1.1", ReceiveProvider.portNo, true, true, networkInfoMock, mockHost);
    });

    test('should be not open port when did not get ip address', () async{
      setupSpyComm(mockHost);
      await checkOpenPort(null, 0, false, false, networkInfoMock, mockHost);
    });

    test('should be close port when call the close method', () async{
      setupSpyComm(mockHost);
      when(mockHost.close()).thenAnswer((_)=>null);
      await checkOpenPort("192.168.1.1", ReceiveProvider.portNo, true, true, networkInfoMock, mockHost);
      verifyNever(mockHost.close());
      provider!.close();
      verify(mockHost.close());
    });
  });
}

void callbackActionTest(MockNetworkInfo networkInfoMock, MockTcpHost mockHost, MockSocket mockSocket) {
  group('callback action test', () {
    ReceiveProvider.networkInfo = networkInfoMock;

    test('should be no action when receive empty string', () async{
      setupSpyComm(mockHost);
      await openPort("192.168.1.1", ReceiveProvider.portNo, networkInfoMock);
      if(receiveCallbackSpy != null){
        Object? obj;
        when(mockSocket.write(obj)).thenReturn(null);
        receiveCallbackSpy!(mockSocket, Uint8List(0));
        verifyNever(mockSocket.write(obj));
      }else{
        fail("did not set receive callback.");
      }
    });

    test('should be action when receive command SENDFILE', () async{
      // setupSpyComm(mockHost);
      // await openPort("192.168.1.1", ReceiveProvider.portNo, networkInfoMock);
      // if(receiveCallbackSpy != null){
      //   Object? obj;
      //   when(mockSocket.write(obj)).thenReturn(null);
      //   receiveCallbackSpy!(mockSocket, Uint8List(0));
      //   verifyNever(mockSocket.write(obj));
      // }else{
      //   fail("did not set receive callback.");
      // }
    });
  });
}

