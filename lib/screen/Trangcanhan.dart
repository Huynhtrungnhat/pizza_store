import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pizza_store/api/controller.dart';
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
      try {
        final response = await http.get(Uri.parse('${AppConstants.User_all}/$userId'));

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
      } catch (e) {
        setState(() {
          errorMessage = 'Lỗi kết nối: $e';
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
                  : ListView(
                      children: [
                        // Hình ảnh container trên đầu
                        Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/pizzalogin.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                radius: 80,
                                backgroundImage: NetworkImage(
                                  // Bạn có thể thay thế URL này bằng hình ảnh avatar từ API hoặc database
                                  userData?['avatar_url'] ?? 'https://www.example.com/avatar.jpg',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                        SizedBox(height: 20),
                        // Thông tin người dùng
                        _buildDetailCard('Tên', userData?['name']),
                        _buildDetailCard('Email', userData?['email']),
                        _buildDetailCard('Ngày tạo', userData?['created_at']?.toString()),
                        Divider(), // Gạch ngang phân chia
                        SizedBox(height: 20),
                        // Thông tin đơn hàng (giả sử bạn có thông tin này từ API)
                        _buildOrderDetailCard('Mã đơn hàng', '12345'),
                        _buildOrderDetailCard('Ngày tạo đơn', '2024-11-10'),
                        _buildOrderDetailCard('Tình trạng đơn hàng', 'Đang xử lý'),
                      ],
                    ),
            ),
    );
  }

  Widget _buildDetailCard(String title, String? value) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text(
              '$title: ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Text(
                value ?? 'N/A',
                style: TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Card cho thông tin đơn hàng
  Widget _buildOrderDetailCard(String title, String value) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text(
              '$title: ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
