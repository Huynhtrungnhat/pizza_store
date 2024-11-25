import 'package:flutter/material.dart';
import 'package:pizza_store/admin/adminlistscren.dart';
import 'package:pizza_store/admin/adminpagedonhang.dart';
import 'package:pizza_store/admin/adminpagekhuyenmai.dart';
import 'package:pizza_store/admin/adminpagenhanvien.dart';
import 'package:pizza_store/admin/adminpagesanpham.dart';
import 'package:pizza_store/admin/adminquanlykh.dart';
import 'package:pizza_store/admin/khuyemmaiadd.dart';
import 'package:pizza_store/admin/timkiemtheosdtupdate.dart';
import 'package:pizza_store/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPage extends StatelessWidget {
  Future<void> clearUserId(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId'); 
    await prefs.remove('isLoggedIn'); 
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang Quản Lý Admin'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            
            _buildAdminOption(
              context,
              'Quản lý danh mục phân loại sản phẩm',
              Icons.shopping_bag,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => adminpagesanpham()),
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
              () =>Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => adminpagenhanvien()),
              ),
            ),
            _buildAdminOption(
              context,
              'Quản lý Đơn đặt hàng',
              Icons.person,
              () =>Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Adminpagedonhang()),
              ),
            ),
            _buildAdminOption(
              context,
              'Quản lý chương trình khuyến mãi',
              Icons.card_giftcard,
              () =>Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Adminpagekhuyenmai()),
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
