import 'package:shared_preferences/shared_preferences.dart';

class AppCache {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future saveAppStatus(String status) async {
    await init();
    await _preferences!.setString("status", status);
  }

  static Future<String> getAppStatus() async {
    await init();
    final status = await _preferences!.getString("status");
    return status ?? '';
  }
}
