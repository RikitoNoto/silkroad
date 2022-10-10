import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:platform/platform.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:silkroad/utils/platform_saver.dart';

import 'platform_saver_test.mocks.dart';

late MockLocalPlatform kPlatformMock;

@GenerateMocks([LocalPlatform])
void main() {

  setUp(() async{
    kPlatformMock = MockLocalPlatform();
  });
  factoryTest();
}

void factoryTest() {
  group('factory test', () {
    test('should be create pc instance when windows', () async {
      when(kPlatformMock.operatingSystem).thenReturn(Platform.windows);
      PlatformSaverIF saver = PlatformSaverIF(platform: kPlatformMock);
      expect(saver is PcSaver, isTrue);
    });

    test('should be create pc instance when macos', () async {
      when(kPlatformMock.operatingSystem).thenReturn(Platform.macOS);
      PlatformSaverIF saver = PlatformSaverIF(platform: kPlatformMock);
      expect(saver is PcSaver, isTrue);
    });

    test('should be create pc instance when linux', () async {
      when(kPlatformMock.operatingSystem).thenReturn(Platform.linux);
      PlatformSaverIF saver = PlatformSaverIF(platform: kPlatformMock);
      expect(saver is PcSaver, isTrue);
    });

    test('should be create pc instance when fuchsia', () async {
      when(kPlatformMock.operatingSystem).thenReturn(Platform.fuchsia);
      PlatformSaverIF saver = PlatformSaverIF(platform: kPlatformMock);
      expect(saver is PcSaver, isTrue);
    });

    test('should be create mobile instance when android', () async {
      when(kPlatformMock.operatingSystem).thenReturn(Platform.android);
      PlatformSaverIF saver = PlatformSaverIF(platform: kPlatformMock);
      expect(saver is MobileSaver, isTrue);
    });

    test('should be create mobile instance when ios', () async {
      when(kPlatformMock.operatingSystem).thenReturn(Platform.iOS);
      PlatformSaverIF saver = PlatformSaverIF(platform: kPlatformMock);
      expect(saver is MobileSaver, isTrue);
    });

    test('should be raise unsupported exception when unknown device', () async {
      when(kPlatformMock.operatingSystem).thenReturn('unknown device');
      expect(() => PlatformSaverIF(platform: kPlatformMock), throwsA(TypeMatcher<UnSupportedDeviceException>()));
    });
  });
}
