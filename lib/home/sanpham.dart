import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pizza_store/api/controller.dart';

import 'package:pizza_store/screen/manhinhchung.dart';

import '../models/sanphamcart.dart';
import '../admin/adminlistscren.dart';
import '../screen/tranggiohang.dart';

class detailsanpham extends StatefulWidget {
  const detailsanpham({super.key});

  @override
  State<detailsanpham> createState() => _detailsanphamState();
}

class _detailsanphamState extends State<detailsanpham> {
  
  
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
    cart.loadCartFromSharedPreferences(); 
    
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
              ? Screenn(list: snapshot.data!)
              : Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: Stack(
        clipBehavior: Clip.none,
        children: [
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Giỏ Hàng',
            child: const Icon(Icons.shopping_cart_rounded),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
              '${cart.getTotalQuantity()}', 
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(
        FloatingActionButtonLocation.endFloat,
        -20.0,
        -80.0,
      ),
    );
  }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  final FloatingActionButtonLocation location;
  final double offsetX;
  final double offsetY;

  CustomFloatingActionButtonLocation(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final Offset originalOffset = location.getOffset(scaffoldGeometry);
    return Offset(originalOffset.dx + offsetX, originalOffset.dy + offsetY);
  }
}
