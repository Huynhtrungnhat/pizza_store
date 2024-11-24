import 'package:flutter/material.dart';
import 'package:pizza_store/admin/adminlistscren.dart';
import 'package:pizza_store/admin/timkhtheohoadon.dart';
import 'package:pizza_store/admin/timkiemtheosdtupdate.dart';
import 'package:pizza_store/admin/trangCTDonHang.dart';

class adminpagkhachhang extends StatelessWidget {
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
              'Tìm kiếm khách hàng theo số điện thoại\nCập nhật thông tin khách hàng (Tên, Số điện thoại, Email, Địa chỉ).',
              Icons.category,
              () => Navigator.push(context,MaterialPageRoute(builder: (context) =>CustomerManagementPage() ),
            ),),
            // _buildAdminOption(
            //   context,
            //   'Cập nhật thông tin khách hàng (Tên, Số điện thoại, Email, Địa chỉ).',
            //   Icons.shopping_bag,
            //   () => Navigator.push(context,MaterialPageRoute(builder: (context) => Screnlisad()),
            //   ),
            //   ),
            _buildAdminOption(
              context,
              'Hiển thị chi tiết thông tin của khách hàng (bao gồm các đơn hàng, lịch sử giao dịch).',
              Icons.people,
              () => Navigator.push(context,MaterialPageRoute(builder: (context) => timkhtheohd(maKhachHang: 1,)),
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
