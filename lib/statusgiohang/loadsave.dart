import 'dart:convert';
import 'package:pizza_store/models/sanphamcart.dart';
import 'package:pizza_store/models/sanphammodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveCartToSharedPreferences(List<Product> items) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> cartList = cart.items.map((item) => json.encode(item.toJson())).toList();
   print('Lưu giỏ hàng vào SharedPreferences: $cartList');  
  await prefs.setStringList('cart', cartList);
}

Future<void> loadCartFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? cartList = prefs.getStringList('cart');
   print('Dữ liệu giỏ hàng từ SharedPreferences: $cartList');  
  
  if (cartList != null && cartList.isNotEmpty) {
    cart.items = cartList.map((item) => Product.fromJson(json.decode(item))).toList();
  }
}


