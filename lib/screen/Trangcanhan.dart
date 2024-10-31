import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class UserProfilePage extends StatefulWidget {
   final String userId; // Thêm thuộc tính userId

  UserProfilePage({required this.userId}); 
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Map<String, dynamic>? userData;
  String? errorMessage;
  bool isLoading = true;
  String? userId; // Biến để lưu ID người dùng

  Future<void> fetchUserData() async {
    // Lấy ID người dùng từ SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');

    if (userId != null) {
      final response = await http.get(Uri.parse('http://192.168.1.122:8000/api/user/$userId'));

      if (response.statusCode == 201) {
        setState(() {
          userData = json.decode(response.body)['user'];
          errorMessage = null;
        });
      } else {
        setState(() {
          errorMessage = 'Không thể tải thông tin người dùng. Mã trạng thái: ${response.statusCode}';
        });
      }
    } else {
      setState(() {
        errorMessage = 'ID người dùng không tìm thấy!';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin cá nhân'),
        centerTitle: true,
      ),
      body: isLoading 
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: errorMessage != null 
                  ? Center(child: Text(errorMessage!, style: TextStyle(color: Colors.red, fontSize: 16)))
                  : Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ID: ${userData?['id'] ?? 'N/A'}',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Tên: ${userData?['name'] ?? 'N/A'}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Email: ${userData?['email'] ?? 'N/A'}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Ngày tạo: ${userData?['created_at'] ?? 'N/A'}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
    );
  }
}
