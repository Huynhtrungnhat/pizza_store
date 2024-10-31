import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId'); // Lấy userId từ SharedPreferences
  }

  static Future<void> saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId); // Lưu userId vào SharedPreferences
  }
}
