import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pizza_store/admin/addsanpham.dart';
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/admin/listproductad.dart';
import '../models/sanphamcart.dart';
import '../screen/tranggiohang.dart';

class Screnlisad extends StatefulWidget {
  const Screnlisad({super.key});

  @override
  State<Screnlisad> createState() => _ScrenlisadState();
}

class _ScrenlisadState extends State<Screnlisad> {
  List productList = [];

  Future<void> getData() async {
    try {
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
        setState(() {
          productList = data['data'];
        });
      } else {
        log('Không thể tải dữ liệu: ${response.statusCode} ${response.body}');
        throw Exception('Không thể tải dữ liệu');
      }
    } catch (e) {
      log('Error fetching data: $e');
      throw e;
    }
  }

  void _incrementCounter() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(),
      ),
    ).then((value) {
      setState(() {
        getData();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    cart.loadCartFromSharedPreferences();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trang chủ Thực đơn"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductInputPage()),
              ).then((result) {
                if (result == true) {
                  setState(() {
                    getData();
                  });
                }
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: getData, // Hàm được gọi khi làm mới
        child: productList.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListAd(list: productList),
      ),
    );
  }
}
