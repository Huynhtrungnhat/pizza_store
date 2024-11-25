import 'package:flutter/material.dart';
import 'package:pizza_store/admin/addsanpham.dart';
import 'package:pizza_store/admin/adminlistscren.dart';

class adminpagesanpham extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang Quản Lý Sản phẩm'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildAdminOption(
              context,
              'Thêm sản phẩm mới ',
              Icons.category,
              () => Navigator.push(context,MaterialPageRoute(builder: (context) =>ProductInputPage() ),
            ),),
            _buildAdminOption(
              context,
              'Cập nhật thông tin sản phẩm.',
              Icons.shopping_bag,
              () => Navigator.push(context,MaterialPageRoute(builder: (context) => Screnlisad())
              ,
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
