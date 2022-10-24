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
  });
}
