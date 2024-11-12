import 'package:flutter/material.dart';
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/screen/chitietsanpham.dart';

class ItemList extends StatelessWidget {
  final List list;

  ItemList({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      padding: EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final product = list[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailPage(
                  product: product,
                ),
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
                product['hinh_anh'] != ""
                    ? Image(
                        image: NetworkImage(
                            '${AppConstants.BASE_URL}${product['hinh_anh']}'),
                        fit: BoxFit.cover,
                        height: 75,
                      )
                    : Text('No image available'),
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
