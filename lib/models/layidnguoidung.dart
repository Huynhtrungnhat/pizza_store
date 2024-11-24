import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class AuthService {
  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId'); // Lấy userId từ SharedPreferences
  }

  static Future<void> saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId); // Lưu userId vào SharedPreferences
  }
   static Future<bool> checkIfAdmin(String userId) async {
    final url = Uri.parse('http://192.168.1.11:8000/api/user/$userId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['quyen'] == 'admin') {
          return true;
        }
      }
    } catch (e) {
      print('Lỗi khi kiểm tra quyền admin: $e');
    }
    return false;
  }
}
