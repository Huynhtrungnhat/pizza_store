import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/login/login.dart';
import 'package:pizza_store/screen/trangsuathongtin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserProfilePage extends StatefulWidget {
  final String userId;

  UserProfilePage({required this.userId});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Map<String, dynamic>? userData;
  String? errorMessage;
  bool isLoading = true;
  String? userId;

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');

    if (userId != null) {
      try {
        final response =
            await http.get(Uri.parse('${AppConstants.User_all}/$userId'));

        if (response.statusCode == 201) {
          setState(() {
            userData = json.decode(response.body)['user'];
            errorMessage = null;
          });
        } else {
          setState(() {
            errorMessage =
                'Không thể tải thông tin người dùng. Mã trạng thái: ${response.statusCode}';
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

  Future<void> clearUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('isLoggedIn');
    await prefs.remove('userRole'); 

    setState(() {
      userId = null;
      userData = null;
      errorMessage = 'Bạn đã đăng xuất';
      isLoading = false;
    });

    fetchUserData();
     Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
  );
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
        title: Text('Thông tin Tài Khoản'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: errorMessage != null
                  ? Center(
                      child: Text(errorMessage!,
                          style: TextStyle(color: Colors.red, fontSize: 16)))
                  : ListView(
                      children: [
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
                                backgroundImage:
                                    AssetImage('assets/images/anhdaidien.jpg'),
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                        SizedBox(height: 10),
                        _buildDetailCard('Tên', userData?['name']),
                        Divider(),
                        _buildDetailCard('Email', userData?['email']),
                        _buildAdminOption(
                          context,
                          'Cập nhật thông tin',
                          Icons.exit_to_app,
                          () async {
                            final updatedName = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditNamePage(
                                  currentName: userData?['name'] ?? '',
                                  email: userData?['email'] ?? '',
                                ),
                              ),
                            );
                            if (updatedName != null) {
                              setState(() {
                                userData?['name'] = updatedName;
                              });
                            }
                          },
                        ),
                        SizedBox(height: 20),
                        _buildAdminOption(
                          context,
                          'Đăng xuất',
                          Icons.exit_to_app,
                          () => clearUserId(),
                        ),
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

  Widget _buildAdminOption(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, size: 30.0),
        title: Text(
          title,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
