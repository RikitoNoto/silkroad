import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:silkroad/option/option_manager.dart';

void main() {
  setUp(() async{
  });

  tearDown(() async{
    SharedPreferences sharedPreferences = (await SharedPreferences.getInstance());
    for(String key in sharedPreferences.getKeys()){
    sharedPreferences.remove(key);
    }
  });

  valueGetTest();
  valueSetTest();
}

Future setValueSpy(String key, Object value) async{
  SharedPreferences.setMockInitialValues(<String, Object>{key: value});
  await OptionManager.initialize();
}

Future checkGetValue(String key, Object value) async{
  await setValueSpy(key, value);
  OptionManager option = OptionManager();
  expect(option.get(key), value);
}

void valueGetTest() {
  group('value get test', () {
    test('should be get value [1]', () async {
      checkGetValue('key', 1);
    });

    test('should be get value [2]', () async {
      checkGetValue('key', 2);
    });

    test('should be get value [A]', () async {
      checkGetValue('key', 'A');
    });

    test('should be get value [true]', () async {
      checkGetValue('key', true);
    });
  });
}

Future checkSetValue(String key, Object value) async{
  OptionManager option = OptionManager();
  await option.set(key, value);
  expect((await SharedPreferences.getInstance()).get(key), value);
}

void valueSetTest() {
  group('value set test', () {
    test('should be set value [1]', () async {
      await checkSetValue('key', 1);
    });

    test('should be set value [0]', () async {
      await checkSetValue('key', 0);
    });

    test('should be set value [A]', () async {
      await checkSetValue('key', 'A');
    });

    test('should be set value [DD]', () async {
      await checkSetValue('key', 'DD');
    });

    test('should be set value [true]', () async {
      await checkSetValue('key', true);
    });

    test('should be set value [false]', () async {
      await checkSetValue('key', false);
    });

    test('should be set value [0.1]', () async {
      await checkSetValue('key', 0.1);
    });

    test('should be raise error when set invalid type', () async {
      OptionManager option = OptionManager();
      expect(()async => (await option.set('key', option)), throwsA(const TypeMatcher<ArgumentError>()));
    });
  });
}
