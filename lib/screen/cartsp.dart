import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/screen/chitietsanpham.dart';

import '../models/sanphamcart.dart';
import '../models/sanphammodel.dart';
import '../home/sanpham.dart';
// Import trang chi tiết sản phẩm

class ItemList extends StatelessWidget {
  final List list;
  final Cart cart;

  ItemList({super.key, required this.list, required this.cart});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Mỗi hàng có 2 container
        childAspectRatio: 3 / 2, // Tỉ lệ chiều rộng/chiều cao của mỗi container
        crossAxisSpacing: 8, // Khoảng cách ngang giữa các container
        mainAxisSpacing: 8, // Khoảng cách dọc giữa các container
      ),
      padding: EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final product = list[index];
        return GestureDetector(
          onTap: () {
            // Điều hướng đến ProductDetailPage khi nhấn vào Container
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailPage(product: product),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 215, 169, 0),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 12,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: product['hinh_anh'] != ""
                      ? Image(
                          image: NetworkImage(
                              '${AppConstants.BASE_URL}${product['hinh_anh']}'),
                          fit: BoxFit.cover,
                          height: 75,
                        )
                      : Text('No image available'),
                ),
                Text(
                  product['ten_san_pham'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text('Giá: ${product['gia']} VND'),
              ],
            ),
          ),
        );
      },
    );
  }
}
