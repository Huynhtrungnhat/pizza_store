import 'package:flutter/material.dart';
import 'package:pizza_store/models/cthoadonModel.dart';

class ChiTietHoaDonScreen extends StatelessWidget {
  final Future<ChiTietHoaDon> futureChiTietHoaDon;

  ChiTietHoaDonScreen({required this.futureChiTietHoaDon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi Tiết Hóa Đơn'),
      ),
      body: FutureBuilder<ChiTietHoaDon>(
        future: futureChiTietHoaDon, 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Không có dữ liệu.'));
          }

          final chiTietHoaDon = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mã chi tiết hóa đơn: ${chiTietHoaDon.maChiTietHoaDon}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text('Mã hóa đơn: ${chiTietHoaDon.maHoaDon}'),
                Text('Mã sản phẩm: ${chiTietHoaDon.maSanPham}'),
                Text('Số lượng: ${chiTietHoaDon.soLuong}'),
                Text('Giá: ${chiTietHoaDon.gia}'),
                Text('Giá khuyến mãi: ${chiTietHoaDon.giaKhuyenMai}'),
              ],
            ),
          );
        },
      ),
    );
  }
  
}
