// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:silkroad/receive/providers/receive_provider.dart';
import 'receive_providers_test.mocks.dart';

@GenerateMocks([NetworkInfo])
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ipAddressTest();
}

void checkIpAddress(MockNetworkInfo mock, String? returnValue, String expectAddress) async {
  when(mock.getWifiIP()).thenAnswer((_)=>Future<String?>.value(returnValue));
  ReceiveProvider provider = ReceiveProvider();
  await mock.getWifiIP();      // for wait complete.
  expect(provider.ipAddress, expectAddress);
}

void ipAddressTest() {

  MockNetworkInfo networkInfoMock = MockNetworkInfo();
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
