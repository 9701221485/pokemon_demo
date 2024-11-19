import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static final SharedPreference instance = SharedPreference();
  Future<bool?> saveList(String key, List<String> values) async {
    try {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      bool result = await pref.setStringList(key, values);
      return result;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<List<String>?> getList(String key) async {
    try {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      List<String>? result = pref.getStringList(key);
      return result;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
