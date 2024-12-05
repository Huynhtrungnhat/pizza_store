import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/login/login.dart';
import 'package:pizza_store/models/cthoadonModel.dart';
import 'package:pizza_store/models/khachhnag.dart';
import 'package:pizza_store/models/modelhoadonkh.dart';
import 'package:pizza_store/screen/cthoadon.dart';
import 'package:pizza_store/screen/fechdatakhhpadon.dart';
import 'package:pizza_store/screen/chitiethoadonme.dart';
import 'package:pizza_store/screen/productadd.dart';
import 'package:pizza_store/screen/trangCTHD.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class timkhtheohdkhmy extends StatefulWidget {

  @override
  _timkhtheohdkhmyState createState() => _timkhtheohdkhmyState();
}
class _timkhtheohdkhmyState extends State<timkhtheohdkhmy> {
  late Future<Map<String, dynamic>?> _futureData;
  String selectedStatus = 'Tất cả'; 

  @override
  void initState() {
    super.initState();
    _futureData = fetchKhachHangHoaDon();
  }

Future<Map<String, dynamic>?> fetchKhachHangHoaDon() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      return null;
    }

    final url = Uri.parse('${AppConstants.BASE_URL}/khachhang/khachhanghd/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Lỗi: ${response.statusCode}');
      print('Thông báo lỗi: ${response.body}');
      return null; 
    }
  } catch (e) {

    print('Lỗi kết nối: $e');
    return null; 
  }
}



  List<HoaDon> filterHoaDons(List<HoaDon> hoaDons) {
    if (selectedStatus == 'Tất cả') {
      return hoaDons;
    } else {
      return hoaDons.where((hoaDon) => hoaDon.trangThai == selectedStatus).toList();
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Thông tin chi tiết các đơn hàng'),
      centerTitle: true,
      backgroundColor: Colors.green,
    ),
    body: FutureBuilder<Map<String, dynamic>?>(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (snapshot.data == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bạn chưa đăng nhập! nên chưa thể xem',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()), 
              );
                  },
                  child: Text('Đăng nhập'),
                ),
              ],
            ),
          );
        }

        final khachHang = KhachHang.fromJson(snapshot.data!['khachhang']);
        final hoaDons = (snapshot.data!['hoa_dons'] as List)
            .map((json) => HoaDon.fromJson(json))
            .toList();

        final filteredHoaDons = filterHoaDons(hoaDons);

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'các đơn hàng đã mua:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedStatus = 'Tất cả';
                          });
                        },
                        child: Text('Tất cả'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedStatus = 'Chờ xác nhận';
                          });
                        },
                        child: Text('Chờ xác nhận'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedStatus = 'Hoàn thành';
                          });
                        },
                        child: Text('Đã hoàn thành'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedStatus = 'Đã hủy';
                          });
                        },
                        child: Text('Đã hủy'),
                      ),
                    ],
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filteredHoaDons.length,
                itemBuilder: (context, index) {
                  final hoaDon = filteredHoaDons[index];

                  return Card(
                    child: ListTile(
                      title: Text('Mã hóa đơn: ${hoaDon.maHoaDon}'),
                      subtitle: Text('Ngày lập: ${hoaDon.ngayLapHd ?? 'Chưa có'}\n'
                          'Tổng tiền: ${hoaDon.tongTien}đ\n'
                          'Trạng thái: ${hoaDon.trangThai ?? 'Chưa xác định'}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InvoiceDetailScreen(
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
  );
}

}
