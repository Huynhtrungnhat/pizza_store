import 'package:flutter/material.dart';
import 'package:pizza_store/admin/addnhanvien.dart';
import 'package:pizza_store/admin/adminlistscren.dart';
import 'package:pizza_store/admin/timkiemtheosdtupdate.dart';
import 'package:pizza_store/admin/trangquanlynahnvien.dart';

class adminpagenhanvien extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang Quản Lý Khách hàng'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildAdminOption(
              context,
              'Thêm Nhân viên mới ',
              Icons.category,
              () => Navigator.push(context,MaterialPageRoute(builder: (context) =>ThemNhanVienPage() ),
            ),),
            _buildAdminOption(
              context,
              'Cập nhật thông tin nhân viên (Tên, Số điện thoại, Email, Địa chỉ).',
              Icons.shopping_bag,
              () => Navigator.push(context,MaterialPageRoute(builder: (context) => Screnlisad()),
              ),
              ),
            _buildAdminOption(
              context,
              'Phân quyền cho Nhân viên',
              Icons.people,
              () => Navigator.push(context,MaterialPageRoute(builder: (context) => nhanvienpermetion()),
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
