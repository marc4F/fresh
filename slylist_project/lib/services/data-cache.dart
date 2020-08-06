import 'package:shared_preferences/shared_preferences.dart';

class DataCache {
  Future<bool> writeString(String key, String val) async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.setString(key, val);
  }

  Future<bool> writeStringList(String key, List<String> val) async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.setStringList(key, val);
  }

  Future<String> readString(String key) async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getString(key) ?? null;
  }

  Future<List<String>> readStringList(String key) async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getStringList(key) ?? null;
  }

  Future<bool> delete(String key) async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.remove(key);
  }

  Future<Set<String>> content() async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getKeys();
  }
}
