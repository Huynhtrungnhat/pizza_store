import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> login(String email, String password) async {
  final url = Uri.parse('https://yourapi.com/api/login'); // Thay bằng URL API của bạn
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final token = data['access_token'];

    // Lưu token vào SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);

    return true; // Đăng nhập thành công
  } else {
    // Đăng nhập thất bại
    print('Đăng nhập thất bại: ${response.body}');
    return false;
  }
}
