import 'package:flutter/material.dart';
import 'package:pizza_store/admin/adminlistscren.dart';
import 'package:pizza_store/admin/adminpagedonhang.dart';
import 'package:pizza_store/admin/adminpagekhuyenmai.dart';
import 'package:pizza_store/admin/adminpagenhanvien.dart';
import 'package:pizza_store/admin/adminpagesanpham.dart';
import 'package:pizza_store/admin/adminquanlykh.dart';
import 'package:pizza_store/admin/khuyemmaiadd.dart';
import 'package:pizza_store/admin/tim_khach_hang_co_hoa_don/timkiemtheosdtupdate.dart';
import 'package:pizza_store/login/login.dart';
import 'package:pizza_store/screen/listkhuyenmai.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screen/listnhanvien.dart';

class AdminPage extends StatelessWidget {
  Future<String> getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userRole') ?? '';  
  }

  Future<void> clearUserId(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId'); 
    await prefs.remove('isLoggedIn'); 
    await prefs.remove('userRole');  
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getUserRole(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(' Bạn chưa đăng nhập'),
          const SizedBox(height: 20), 
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()), 
              );
            },
            child: const Text('Đăng nhập'),
          ),
        ],
      ),
    );
        }

        String userRole = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text('Trang Quản Lý Admin'),
            centerTitle: true,
            backgroundColor: Colors.amber,
            actions: [
              IconButton(
                icon: Icon(Icons.logout_outlined),
                onPressed: () async {
                  await clearUserId(context);
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                if (userRole == 'admin') ...[  
                  _buildAdminOption(
                    context,
                    'Quản lý danh mục phân loại sản phẩm',
                    Icons.shopping_bag,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Screnlisad()),
                    ),
                  ),
                  _buildAdminOption(
                    context,
                    'Quản lý thông tin khách hàng',
                    Icons.people,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => adminpagkhachhang()),
                    ),
                  ),
                  _buildAdminOption(
                    context,
                    'Quản lý thông tin nhân viên',
                    Icons.person,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NhanVienListScreen()),
                    ),
                  ),
                  _buildAdminOption(
                    context,
                    'Quản lý Đơn đặt hàng',
                    Icons.shopping_cart,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Adminpagedonhang()),
                    ),
                  ),
                  _buildAdminOption(
                    context,
                    'Quản lý chương trình khuyến mãi',
                    Icons.card_giftcard,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => KhuyenMaiScreen()),
                    ),
                  ),
                ] else if (userRole == 'nv') ...[  
                  _buildAdminOption(
                    context,
                    'Quản lý thông tin khách hàng',
                    Icons.people,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => adminpagkhachhang()),
                    ),
                  ),
                  _buildAdminOption(
                    context,
                    'Quản lý Đơn đặt hàng',
                    Icons.shopping_cart,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Adminpagedonhang()),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
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

