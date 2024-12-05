import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/models/cthoadonModel.dart';
import 'package:pizza_store/models/khachhnag.dart';
import 'package:pizza_store/models/modelhoadonkh.dart';
import 'package:pizza_store/screen/cthoadon.dart';
import 'package:pizza_store/screen/fechdatakhhpadon.dart';

import 'package:pizza_store/screen/chitiethoadonme.dart';
import 'package:pizza_store/screen/productadd.dart';
import 'package:pizza_store/screen/trangCTHD%20(1).dart';
import 'package:pizza_store/screen/trangCTHD.dart';
import 'package:http/http.dart' as http;

class Timhoadoncuakhachhang extends StatefulWidget {
  final int mahoadon;

  Timhoadoncuakhachhang({required this.mahoadon});

  @override
  _TimhoadoncuakhachhangState createState() => _TimhoadoncuakhachhangState();
}

class _TimhoadoncuakhachhangState extends State<Timhoadoncuakhachhang> {
  late Future<Map<String, dynamic>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = fetchKhachHangHoaDon();
   
  }
  Future<Map<String, dynamic>> fetchKhachHangHoaDon() async {
    final url = Uri.parse('${AppConstants.hoadon}/hdkh/${widget.mahoadon}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      
      print('Lỗi: ${response.statusCode}');
      print('Thông báo lỗi: ${response.body}');
      throw Exception('Không thể tải dữ liệu khách hàng');
    }
  }
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Hóa Đơn Khách Hàng'),
      centerTitle: true,
        backgroundColor: Colors.green,
    ),
    body: FutureBuilder<Map<String, dynamic>>(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('Không có dữ liệu.'));
        }

        final khachHang = KhachHang.fromJson(snapshot.data!['khachhang']);
        final hoaDon = HoaDon.fromJson(snapshot.data!['hoa_don']); 

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Text(
              //     'Thông tin khách hàng:',
              //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              //   ),
              // ),
              // ListTile(
              //   title: Text(khachHang.tenKhachHang),
              //   subtitle: Text('Địa chỉ: ${khachHang.diaChi}\n'
              //       'SĐT: ${khachHang.sdt}\n'
              //       'Điểm mua hàng: ${khachHang.diemMuaHang}'),
              // ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Hóa đơn ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
               Divider(),
              Card(
                child: ListTile(
                  title: Text('Mã hóa đơn: ${hoaDon.maHoaDon}'),
                  subtitle: Text('Ngày lập: ${hoaDon.ngayLapHd ?? 'Chưa có'}\n'
                      'Tổng tiền: ${hoaDon.tongTien}đ\n'
                      'Trạng thái: ${hoaDon.trangThai ?? 'Chưa xác định'}\n'
                      'Phương thức thanh toán: ${hoaDon.pttt ?? 'Chưa xác định'}'
                      ),
                      
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InvoiceDetailsScreenkk(
                          maHoaDon: hoaDon.maHoaDon,
                          makh: khachHang.maKhachHang,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

}
