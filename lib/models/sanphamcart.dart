import 'dart:convert';

import 'package:pizza_store/models/sanphammodel.dart';
import 'package:pizza_store/statusgiohang/loadsave.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Cart {
  List<Product> items = [];

  void addsanpham(Product product) {
    int index = items.indexWhere((item) => item.ten_san_pham == product.ten_san_pham);

    if (index != -1) {
      items[index].so_luong_ton_kho += product.so_luong_ton_kho;
    } else {
      items.add(product);
    }
  }

  void updateQuantity(Product product, int newQuantity) {
    int index = items.indexWhere((item) => item.ten_san_pham == product.ten_san_pham);
    if (index != -1) {
      if (newQuantity > 0) {
       
        items[index].so_luong_ton_kho = newQuantity;
        saveCartToSharedPreferences(cart.items);
      } else {
        items.removeAt(index);
        saveCartToSharedPreferences(cart.items);
      }
    }
  }

  double getTotalPrice() {
    double total = 0;
    for (var item in items) {
      total += item.gia * item.so_luong_ton_kho;
    }
    return total;
  }

  double getTotalPricekm() {
    double total = 0;
    for (var item in items) {
      total += item.gia * item.so_luong_ton_kho;
    }
    return total;
  }

  int getTotalQuantity() {
    Set<String> processedProductNames = {};
    int totalQuantity = 0;

    for (var item in items) {
      if (!processedProductNames.contains(item.ten_san_pham)) {
        totalQuantity += item.so_luong_ton_kho;
        processedProductNames.add(item.ten_san_pham);
      }
    }
    return totalQuantity;
  }

  Future<void> loadCartFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? cartList = prefs.getStringList('cart');
 // print('Dữ liệu giỏ hàng từ SharedPreferences: $cartList'); 

  if (cartList != null && cartList.isNotEmpty) {
    items = cartList.map((item) => Product.fromJson(json.decode(item))).toList();
  }
}



  void clear() {
    items.clear();
    saveCartToSharedPreferences(items); 
  }
}

Cart cart = Cart();
