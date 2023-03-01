import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPref {

  void save(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  Future<dynamic> read(String key) async{
    
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getString(key) == null) return null;

    final String? value = prefs.getString(key);
    String valueOk = "";
    if (value?.isEmpty == false){
      valueOk = value!; 
    }
    return json.decode(valueOk);

  }

  // Si existe un valor con una jey establecida
  Future<bool> contains(String key) async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  Future<bool> remove(String key) async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

}