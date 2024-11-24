import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/models/hoadonModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HoaDonDetailPageKh extends StatefulWidget {
  final HoaDon order;
  final Function(String) onUpdateStatus;

  HoaDonDetailPageKh({
    required this.order,
    required this.onUpdateStatus,
  });

  @override
  _HoaDonDetailPageKhState createState() => _HoaDonDetailPageKhState();
}

class _HoaDonDetailPageKhState extends State<HoaDonDetailPageKh> {

  final List<String> _statusList = [
    'Chờ xác nhận',
    'Đang vận chuyển',
    'Hoàn thành',
    'Đã hủy',
  ];
  var customerId; 
  String? userId;

  late String _selectedStatus;

 @override
void initState() {
  super.initState();
  _selectedStatus = _statusList.contains(widget.order.trang_thai)
      ? widget.order.trang_thai
      : _statusList.first;
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
              Text('Mã đơn hàng: ${widget.order.ma_hoa_don}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Tổng tiền: ${widget.order.tong_tien.toStringAsFixed(2)} đ', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Trạng thái:${widget.order.trang_thai}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 5),
              // ElevatedButton(
              //   onPressed: () => _updateStatusOnApi(_selectedStatus),
              //   child: Text('Cập nhật trạng thái'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
