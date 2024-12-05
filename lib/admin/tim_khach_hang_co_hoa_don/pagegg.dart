import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pizza_store/admin/tim_khach_hang_co_hoa_don/timkhtheohoadon.dart';
import 'package:pizza_store/api/controller.dart';

class timkhcohd extends StatefulWidget {
  @override
  _timkhcohdState createState() => _timkhcohdState();
}

class _timkhcohdState extends State<timkhcohd> {

  final TextEditingController searchController = TextEditingController();
  String customerDetails = "";
  bool isCustomerFound = false;
  var customerId; 


Future<void> searchCustomerByPhone() async {
  if (searchController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Vui lòng nhập mã đơn hàng')),
    );
    return;
  }

  try {

    final int makh = int.parse(searchController.text.trim());

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => timkhtheohd(maKhachHang: makh),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mã đơn hàng phải là số hợp lệ')),
    );
  }
}


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text("Quản lý khách hàng")),
    body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/nendep.jpg'), 
              fit: BoxFit.cover, 
            ),
          ),
        ),

        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'Nhập mã đơn để tìm kiếm',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: searchCustomerByPhone,
                  child: Text('Tìm kiếm'),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

}
