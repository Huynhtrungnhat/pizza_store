import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pizza_store/models/cthoadonModel.dart';

class ApiService {
  Future<Map<String, dynamic>> fetchKhachHangHoaDon() async {
    final url = Uri.parse('http://172.20.10.9:8000/api/khachhang/khachhanghd/1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      
      print('Lỗi: ${response.statusCode}');
      print('Thông báo lỗi: ${response.body}');
      throw Exception('Không thể tải dữ liệu khách hàng');
    }
  }
//   Future<List<ChiTietHoaDon>> fetchChiTietHoaDon() async {
//   final response = await http.get(Uri.parse('http://192.168.1.20:8000/api/cthoadon'));

//   if (response.statusCode == 200) {
//     final List<dynamic> data = json.decode(response.body)['cthoadon'];
//     return data.map((item) => ChiTietHoaDon.fromJson(item)).toList();
//   } else {
//     throw Exception('Không thể tải dữ liệu');
//   }
// }
}

