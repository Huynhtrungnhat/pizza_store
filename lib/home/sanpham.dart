import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/models/sanphamcart.dart';
import 'package:pizza_store/screen/manhinhchung.dart';

import '../screen/cartsp.dart';

// import 'detail.dart';
class detailsanpham extends StatefulWidget {
  const detailsanpham({super.key});

  @override
  State<detailsanpham> createState() => _detailsanphamState();
}

class _detailsanphamState extends State<detailsanpham> {
   final Cart cart = Cart();
  Future<List> getData() async {
  // var url = Uri.parse("http://localhost:8000/api/sanpham");
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
    return data['data']; // Giả sử dữ liệu bạn cần nằm trong thuộc tính 'data'
  } else {
    print('Không thể tải dữ liệu: ${response.statusCode} ${response.body}');
    throw Exception('Không thể tải dữ liệu');
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sản phẩm"),
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
    );
  }
  
}





