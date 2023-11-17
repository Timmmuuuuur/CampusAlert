import 'package:shared_preferences/shared_preferences.dart';

class SPStringPair {
  // Shared preference string pair: key string -> value string
  final String key;

  SPStringPair(this.key);

  Future<void> set(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> get() async {
    if (await exist()) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key)!;
    }

    return null;
  }

  Future<bool> exist() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  Future<void> remove() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
