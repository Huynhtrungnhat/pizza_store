import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pizza_store/models/usermodel.dart';

Future<User> fetchUserProfile() async {
  try {
    final response = await http.get(Uri.parse('http://192.168.1.122:8000/api/user/22'));

    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      print('Lỗi: ${response.statusCode} - ${response.body}');
      throw Exception('Lỗi khi tải dữ liệu từ API');
    }
  } catch (e) {
    print('Lỗi khi kết nối API: $e');
    throw Exception('Lỗi khi tải dữ liệu');
  }
}

