import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pizza_store/api/controller.dart';

class ThemNhanVienPage extends StatefulWidget {
  @override
  _ThemNhanVienPageState createState() => _ThemNhanVienPageState();
}

class _ThemNhanVienPageState extends State<ThemNhanVienPage> {
  TextEditingController _tenNhanVienController = TextEditingController();
  TextEditingController _diaChiController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _sdtController = TextEditingController();
  TextEditingController _ngaySinhController = TextEditingController();
  TextEditingController _trangThaiController = TextEditingController();

  int _gioiTinh = 1; // 1 cho Nam, 2 cho Nữ, v.v.
  String? sizepiza;

  // Thêm nhân viên qua API
  Future<void> Themnhanvien( String ten_san_pham,int ma_loai_nhan_vien,int gioi_tinh,String ngay_sinh,String dia_chi,String email,String sdt,String trang_thai) async {
    final url = Uri.parse('${AppConstants.nhanvien}');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'appliaction/json',
        },
        body: jsonEncode({
            'ten_nhan_vien': ten_san_pham,
            'ma_loai_nhan_vien': ma_loai_nhan_vien, 
            'gioi_tinh': gioi_tinh,
            'ngay_sinh': ngay_sinh,
            'dia_chi': dia_chi,
            'email': email,
            'sdt': sdt,
            'trang_thai': trang_thai,
          
        }),
      );

      if (response.statusCode == 201) {
        print('Nhân viên đã được thêm thành công');
        print('Response body: ${response.body}');
      } else {
        print('Lỗi khi thêm nhân viên. Mã lỗi: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Lỗi khi thực hiện yêu cầu: $error');
    }
  }
  Future<void> addUser(String name, String email, String password,String quyen) async {
    final url = Uri.parse('${AppConstants.BASE_URL}/register');
    final response = await http.post(
      url, 
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'quyen':quyen,
      }),
    );
  }

  // Chọn ngày sinh
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        _ngaySinhController.text = '${pickedDate.toLocal()}'.split(' ')[0]; // Chỉ lấy ngày tháng năm
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm Nhân Viên'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
    final ten_nhan_vien = _tenNhanVienController.text;
    final ma_loai_nhan_vien = 1; 
    final gioi_tinh = _gioiTinh; 
    final ngay_sinh = _ngaySinhController.text; 
    final dia_chi = _diaChiController.text;
    final email = _emailController.text;
    final trang_thai = _trangThaiController.text;
    final sdt = _sdtController.text;
    final pass="pizadnd@123";
    final quyen="null";

        print('Tên: $ten_nhan_vien');
        print('Mã loại: $ma_loai_nhan_vien');
        print('Giới tính: $gioi_tinh');
        print('Ngày sinh: $ngay_sinh');
        print('Địa chỉ: $dia_chi');
        print('Email: $email');
        print('Trạng thái: $trang_thai');
        print('Số điện thoại: $sdt');

 
    if (ten_nhan_vien.isNotEmpty && ngay_sinh.isNotEmpty) {
     
      await Themnhanvien(ten_nhan_vien, ma_loai_nhan_vien, gioi_tinh, ngay_sinh, dia_chi, email, sdt, trang_thai);
      addUser(ten_nhan_vien, email, pass,quyen);
      Navigator.pop(context);
    } else {
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin!')),
      );
    }
              }  
          ),
        ],
      ),
      body: SingleChildScrollView(  
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tên Nhân Viên:'),
              TextField(
                controller: _tenNhanVienController,
                decoration: InputDecoration(hintText: 'Nhập tên nhân viên'),
              ),
              SizedBox(height: 10),
              Text('Giới Tính:'),
              Row(
                children: [
                  Radio<int>(
                    value: 1,
                    groupValue: _gioiTinh,
                    onChanged: (value) {
                      setState(() {
                        _gioiTinh = value!;
                      });
                    },
                  ),
                  Text('Nam'),
                  Radio<int>(
                    value: 0,
                    groupValue: _gioiTinh,
                    onChanged: (value) {
                      setState(() {
                        _gioiTinh = value!;
                      });
                    },
                  ),
                  Text('Nữ'),
                ],
              ),
              SizedBox(height: 10),
              Text('Ngày Sinh:'),
              TextField(
                controller: _ngaySinhController,
                decoration: InputDecoration(
                  hintText: 'Chọn ngày sinh',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,  
              ),
              SizedBox(height: 10),
              Text('Địa Chỉ:'),
              TextField(
                controller: _diaChiController,
                decoration: InputDecoration(hintText: 'Nhập địa chỉ'),
              ),
              SizedBox(height: 10),
              Text('Email:'),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(hintText: 'Nhập email'),
              ),
              SizedBox(height: 10),
              Text('Số Điện Thoại:'),
              TextField(
                controller: _sdtController,
                decoration: InputDecoration(hintText: 'Nhập số điện thoại'),
              ),
              SizedBox(height: 10),
              Text('Trạng Thái:'),
              TextField(
                controller: _trangThaiController,
                decoration: InputDecoration(hintText: 'Nhập trạng thái'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
