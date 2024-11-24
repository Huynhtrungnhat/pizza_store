import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pizza_store/admin/trangCTDonHang.dart';
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/models/hoadonModel.dart';
import 'package:pizza_store/screen/chitiethoasdonkh.dart';

class QuanLyDonHangkh extends StatefulWidget {
  const QuanLyDonHangkh({super.key});

  @override
  State<QuanLyDonHangkh> createState() => _QuanLyDonHangkhState();
}

class _QuanLyDonHangkhState extends State<QuanLyDonHangkh> {
  List<HoaDon> allOrders = [];
  List<HoaDon> filteredOrders = [];
  bool isLoading = true;
  String selectedStatus = 'Tất cả';

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse('http://172.20.10.9:8000/api/hoadon/khach-hang/danh-sach-hoa-don-cho-khach-hang/1');
    try {
      final response = await http.get(url);

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('data')) {
          final List<dynamic> orderList = data['data'];

          setState(() {
            allOrders = orderList.map((json) => HoaDon.fromJson(json)).toList();
            filterOrders();
            isLoading = false;
          });
        } else {
          throw Exception('Key "user" not found in response data');
        }
      } else {
        throw Exception('Failed to load orders. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading orders: $e')),
      );
    }
  }


  void filterOrders() {
    setState(() {
      if (selectedStatus == 'Tất cả') {
        filteredOrders = allOrders;
      } else {
        filteredOrders = allOrders.where((order) => order.trang_thai == selectedStatus).toList();
      }
    });
  }

  Widget buildFilterButtons() {
    const statuses = ['Tất cả', 'Chờ xác nhận', 'Đang vận chuyển', 'Hoàn thành', 'Đã hủy'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: statuses.map((status) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedStatus == status ? Colors.orange : Colors.white,
              foregroundColor: selectedStatus == status ? Colors.white : Colors.orange,
              side: BorderSide(color: Colors.orange, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              setState(() {
                selectedStatus = status;
                filterOrders();
              });
            },
            child: Text(status),
          );
        }).toList(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đơn Hàng Của Tôi'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildFilterButtons(),
          ),
          Expanded(
            child: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];
                  final formattedDate = order.ngay_lap_hd != null
                      ? DateFormat('dd/MM/yyyy').format(DateTime.parse(order.ngay_lap_hd!))
                      : 'N/A';

                  final double tongTienDouble = double.tryParse(order.tong_tien.toString()) ?? 0.0;
                  final formattedTien = tongTienDouble.toStringAsFixed(2);

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orange,
                        child: Text(order.ma_hoa_don.toString()),
                      ),
                      title: Text(formattedDate),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tổng tiền: ${formattedTien} đ'),
                          Text('Trạng thái: ${order.trang_thai}'),
                        ],
                      ),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HoaDonDetailPageKh(
                              order: order,
                              onUpdateStatus: (newStatus) {
                                setState(() {
                                });
                              },
                            ),
                          ),
                        );

                        if (result == true) {
                          fetchOrders();
                        }
                      },
                    ),
                  );
                },
              ),
          ),
        ],
      ),
    );
  }
}
