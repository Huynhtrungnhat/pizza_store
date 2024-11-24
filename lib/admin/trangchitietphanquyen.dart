import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/models/usermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuanLynahnviendetail extends StatefulWidget {
  final User nv;
  final Function(String) onUpdateStatus;

  QuanLynahnviendetail({
    required this.nv,
    required this.onUpdateStatus,
  });

  @override
  _QuanLynahnviendetailState createState() => _QuanLynahnviendetailState();
}

class _QuanLynahnviendetailState extends State<QuanLynahnviendetail> {

  final List<String> _statusList = [
    'nhân viên',
  ];
  var customerId; 
  String? userId;

  late String _selectedStatus;

 @override
void initState() {
  super.initState();
  _selectedStatus = _statusList.contains(widget.nv.quyen)
      ? widget.nv.quyen
      : _statusList.first;
}

  Future<void> _updateStatusOnApi(String newStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    final url = Uri.parse('${AppConstants.hoadon}/${widget.nv.id}');

    try {
      final requestBody = jsonEncode({
        'id': widget.nv.id,
        'quyen': newStatus,
        'updated_at': DateTime.now().toIso8601String(),
      });

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          widget.nv.quyen = newStatus;
        });
        widget.onUpdateStatus(newStatus);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Trạng thái đơn hàng đã được cập nhật $userId.')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật trạng thái thất bại!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra khi cập nhật trạng thái. Chi tiết lỗi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết Đơn hàng'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Email: ${widget.nv.email}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Họ tên: ${widget.nv.name} ', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
            //  Text(':', style: TextStyle(fontSize: 18)),
              SizedBox(height: 5),
              DropdownButton<String>(
                value: _selectedStatus,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedStatus = newValue;
                    });
                  }
                },
                items: _statusList.map<DropdownMenuItem<String>>((String value) {
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
      ),
    );
  }
}
