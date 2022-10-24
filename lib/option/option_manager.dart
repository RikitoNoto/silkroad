
import 'package:shared_preferences/shared_preferences.dart';

class OptionManager{
  static final OptionManager _instance = OptionManager._internal();
  OptionManager._internal();

  factory OptionManager() => _instance;

  static late SharedPreferences _sharedPreferences;

  static Future initialize() async{
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  // static final Map<String, Object> _key = <String, Object>{};
  //
  // static void readAllValue() async{
  //   for(String key in (await SharedPreferences.getInstance()).getKeys()){
  //     _key[key] = (await SharedPreferences.getInstance()).get(key);
  //   }
  // }

  Object? get(String key){
    return _sharedPreferences.get(key);
  }

}
