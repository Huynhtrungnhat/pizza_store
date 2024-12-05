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

class timkhtheohd extends StatefulWidget {
  final int maKhachHang;

  timkhtheohd({required this.maKhachHang});

  @override
  _timkhtheohdState createState() => _timkhtheohdState();
}

class _timkhtheohdState extends State<timkhtheohd> {
  late Future<Map<String, dynamic>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = fetchKhachHangHoaDon();
   
  }
  Future<Map<String, dynamic>> fetchKhachHangHoaDon() async {
    final url = Uri.parse('${AppConstants.BASE_URL}/khachhang/khachhanghd/${widget.maKhachHang}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      
      print('Lỗi: ${response.statusCode}');
      print('Thông báo lỗi: ${response.body}');
      throw Exception('Không thể tải dữ liệu khách hàng');
    }
  }
 Future<ChiTietHoaDon> fetchChiTietHoaDon(int maHoaDon) async {
  final response = await http.get(Uri.parse('${AppConstants.cthoadondh}/1'));

  if (response.statusCode == 201) {
    final Map<String, dynamic> data = json.decode(response.body)['cthoadon'];
    return ChiTietHoaDon.fromJson(data);
  } else {
    throw Exception('Không thể tải dữ liệu chi tiết hóa đơn');
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Hóa Đơn Khách Hàng'),
       centerTitle: true,
        backgroundColor: Colors.blue,
      
    ),
    body: Stack(
      children: [
        Container(
           width: double.infinity,
      height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/nendep.jpg'),
              fit: BoxFit.cover, 
            ),
          ),
        ),
        FutureBuilder<Map<String, dynamic>>(
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
            final hoaDons = (snapshot.data!['hoa_dons'] as List)
                .map((json) => HoaDon.fromJson(json))
                .toList();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Thông tin khách hàng:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, 
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      khachHang.tenKhachHang,
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(
                      'Địa chỉ: ${khachHang.diaChi}\n'
                      'SĐT: ${khachHang.sdt}\n'
                      'Điểm mua hàng: ${khachHang.diemMuaHang}',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Divider(color: Colors.black),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Danh sách hóa đơn:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: hoaDons.length,
                    itemBuilder: (context, index) {
                      final hoaDon = hoaDons[index];
                      return Card(
                        color: Colors.white70, 
                        child: ListTile(
                          title: Text('Mã hóa đơn: ${hoaDon.maHoaDon}'),
                          subtitle: Text(
                            'Ngày lập: ${hoaDon.ngayLapHd ?? 'Chưa có'}\n'
                            'Tổng tiền: ${hoaDon.tongTien}đ\n'
                            'Trạng thái: ${hoaDon.trangThai ?? 'Chưa xác định'}\n'
                            'Trạng thái: ${hoaDon.pttt ?? 'Chưa xác định'}',
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
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
}

}
