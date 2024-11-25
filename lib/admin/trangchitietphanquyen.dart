import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/models/nhanvienModel.dart';
import 'package:pizza_store/models/usermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuanLynahnviendetail extends StatefulWidget {
  final NhanVien nv; // Nhận đối tượng nhân viên
  final Function(String) onUpdateStatus;

  QuanLynahnviendetail({
    required this.nv,
    required this.onUpdateStatus,
  });

  @override
  _QuanLynahnviendetailState createState() => _QuanLynahnviendetailState();
}

class _QuanLynahnviendetailState extends State<QuanLynahnviendetail> {
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    // Đặt giá trị mặc định cho trạng thái
    _selectedStatus = widget.nv.maNhanVien as String;
  }

  Future<void> _updateStatusOnApi(String newStatus) async {
    // Lấy thông tin userId và gọi API cập nhật trạng thái
    // (tương tự như trong đoạn code của bạn)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết Nhân viên'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tên nhân viên: ${widget.nv.tenNhanVien}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Email: ${widget.nv.email}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedStatus,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedStatus = newValue!;
                });
              },
              items: ['nhân viên'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _updateStatusOnApi(_selectedStatus),
              child: Text('Cập nhật trạng thái'),
            ),
          ],
        ),
      ),
    );
  }
}
