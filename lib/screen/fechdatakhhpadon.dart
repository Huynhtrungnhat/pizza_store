import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/models/khuyenmaimodel.dart';

import 'package:pizza_store/models/nhanvienModel.dart';

class ApiService {
  Future<Map<String, dynamic>> fetchKhachHangHoaDon() async {
    final url = Uri.parse('http://192.168.1.10:8000/api/khachhang/khachhanghd/1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      
      print('Lỗi: ${response.statusCode}');
      print('Thông báo lỗi: ${response.body}');
      throw Exception('Không thể tải dữ liệu khách hàng');
    }
  }
  Future<List<NhanVien>> fetchNhanVien() async {
  final response = await http.get(Uri.parse('${AppConstants.nhanvien}'));

  if (response.statusCode == 201) {
    final jsonData = json.decode(response.body);
    final List<dynamic> nhanVienList = jsonData['nhanvien'];
    return nhanVienList.map((json) => NhanVien.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load data');
  }
  
}
Future<bool> updateNhanVien(NhanVien nhanVien) async {
    final url = Uri.parse('${AppConstants.nhanvien}/${nhanVien.maNhanVien}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(nhanVien.toJson()),
    );
    return response.statusCode == 200; 
  }
}

