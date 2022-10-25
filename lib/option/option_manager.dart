
import 'package:shared_preferences/shared_preferences.dart';

class OptionManager{
  static final OptionManager _instance = OptionManager._internal();
  OptionManager._internal();

  factory OptionManager() => _instance;

  static late SharedPreferences _sharedPreferences;

  static Future initialize() async{
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Object? get(String key){
    return _sharedPreferences.get(key);
  }

  Future set(String key, Object value) async{
    if(value is int){
      await _sharedPreferences.setInt(key, value);
    }
    else if(value is double){
      await _sharedPreferences.setDouble(key, value);
    }
    else if(value is String){
      await _sharedPreferences.setString(key, value);
    }
    else if(value is bool){
      await _sharedPreferences.setBool(key, value);
    }
    else{
      throw ArgumentError('invalid type. should be set type [int], [double], [String], [bool].');
    }
  }

}
