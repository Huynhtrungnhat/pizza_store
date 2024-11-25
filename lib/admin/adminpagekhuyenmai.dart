import 'package:flutter/material.dart';
import 'package:pizza_store/admin/timkhtheohoadon.dart';

import 'package:pizza_store/admin/trangQuanLyDonHang.dart';
import 'package:pizza_store/screen/listkhuyenmai.dart';
import 'package:pizza_store/screen/themkhuyenmai.dart';


class Adminpagekhuyenmai extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang Quản Lý Khuyến mãi'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildAdminOption(
              context,
              'Cập nhật Trạng thái khuyến mãi ',
              Icons.category,
              () => Navigator.push(context,MaterialPageRoute(builder: (context) =>Addkhuyenmaiad() ),
            ),),
            _buildAdminOption(
              context,
              'Thêm khuyến mãi',
              Icons.shopping_bag,
              () => Navigator.push(context,MaterialPageRoute(builder: (context) => Addkhuyenmaiad()),
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
