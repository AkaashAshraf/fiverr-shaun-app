import 'package:shared_preferences/shared_preferences.dart';

Future<void> writeCache(String label, String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(label, value);
}

Future<String?> readCache(String label) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(label);
}
