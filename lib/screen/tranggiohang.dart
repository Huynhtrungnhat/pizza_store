import 'package:flutter/material.dart';
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/models/sanphamcart.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giỏ hàng"),
      ),
      body: cart.items.isEmpty
          ? Center(child: Text('Giỏ hàng trống'))
          : ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                var item = cart.items[index];
                return ListTile(
                  title: Text(item.ten_san_pham),
                  subtitle: Text('Giá: ${item.gia} VND x ${item.so_luong_ton_kho}'),
                  leading: Image.network(
                    
                    '${AppConstants.BASE_URL}${item.hinh_anh}',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Tổng cộng: ${cart.getTotalPrice().toStringAsFixed(2)} VND',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
