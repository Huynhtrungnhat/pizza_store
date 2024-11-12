import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/admin/listproductad.dart';

import 'package:pizza_store/screen/manhinhchung.dart';

import '../models/sanphamcart.dart';
import 'adminlistscren.dart';
import '../screen/tranggiohang.dart';

class Screnlisad extends StatefulWidget {
  const Screnlisad({super.key});

  @override
  State<Screnlisad> createState() => _ScrenlisadState();
}

class _ScrenlisadState extends State<Screnlisad> {
  
  Future<List> getData() async {
    log('${AppConstants.BASE_URL}/sanpham');
    final response = await http.get(
      Uri.parse('${AppConstants.BASE_URL}/sanpham'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    
    if (response.statusCode == 201) {
      var data = json.decode(response.body);
      return data['data']; 
    } else {
      print('Không thể tải dữ liệu: ${response.statusCode} ${response.body}');
      throw Exception('Không thể tải dữ liệu');
    }
  }

  void _incrementCounter() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(),
      ),
    ).then(
      (value) {
        setState(() {
          cart.getTotalQuantity();
        });
      },
    );
  }
    @override
  void initState() {
    super.initState();
    cart.loadCartFromSharedPreferences(); // Tải giỏ hàng từ SharedPreferences khi bắt đầu
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trang chủ Thực đơn"),
      ),
      body: FutureBuilder<List>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          return snapshot.hasData
              ? ListAd(list: snapshot.data!)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
}
}
