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

  MockNetworkInfo networkInfoMock = MockNetworkInfo();
  ReceiveProvider.networkInfo = networkInfoMock;

  group('receive provider tests', () {
    // test('should be initialize and get ip address (255.255.255.255)', (){
    //   ReceiveProvider provider = ReceiveProvider(ip: "255.255.255.255");
    //   expect(provider.ipaddress, "255.255.255.255");
    // });
    //
    // test('should be initialize and get ip address (0.0.0.0)', (){
    //   ReceiveProvider provider = ReceiveProvider(ip: "0.0.0.0");
    //   expect(provider.ipaddress, "0.0.0.0");
    // });

    test('should be get the ip address when initialize(0.0.0.0)', () async {
      when(networkInfoMock.getWifiIP()).thenAnswer((_)=>Future<String>.value("0.0.0.0"));
      ReceiveProvider provider = ReceiveProvider();
      expect(provider.ipaddress, "0.0.0.0");
    });

  });
}
