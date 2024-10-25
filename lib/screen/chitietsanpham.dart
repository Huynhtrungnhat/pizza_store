import 'package:flutter/material.dart';
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/home/sanpham.dart';
import 'package:pizza_store/models/sanphamcart.dart';
import 'package:pizza_store/models/sanphammodel.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;

  ProductDetailPage({super.key, required this.product});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;
  var sdf=0;

  void incrementQuantity() {
    int stock = widget.product['so_luong_ton_kho'] ?? 0;
    if (quantity < stock) {
      setState(() {
        quantity++;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể thêm nhiều hơn số lượng tồn kho'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  void addToCart() {
    Product product = Product(
      ten_san_pham: widget.product['ten_san_pham'],
      gia: double.tryParse(widget.product['gia']) ?? 0.0,
      so_luong_ton_kho: quantity,
      hinh_anh: widget.product['hinh_anh'], mo_ta: '',
    );

    cart.addsanpham(product);
     print('Tổng số lượng sản phẩm trong giỏ hàng: ');
     setState(() {
        sdf=cart.getTotalQuantity();
     });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã thêm ${cart.getTotalQuantity()}'),
        duration: Duration(seconds: 2),
      ),

    );
   Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => detailsanpham()),
              (Route<dynamic> route) => false, // Xóa tất cả các trang trước đó
            );
  }

  @override
  Widget build(BuildContext context) {
    int stock = widget.product['so_luong_ton_kho'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết sản phẩm"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  '${AppConstants.BASE_URL}${widget.product['hinh_anh']}',
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 24),
              Center(
                child: Text(
                  widget.product['ten_san_pham'],
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              Text('Giá: ${widget.product['gia']} VND'),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Số lượng:', style: TextStyle(fontSize: 18)),
                  Row(
                    children: [
                      IconButton(icon: Icon(Icons.remove), onPressed: decrementQuantity),
                      Text('$quantity', style: TextStyle(fontSize: 20)),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: (quantity < stock) ? incrementQuantity : null,
                        color: (quantity < stock) ? Colors.black : Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
Text(
  'Mô tả :',
  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
),
SizedBox(height: 8),
Container(
  padding: EdgeInsets.all(12.0),
 
  child: Text(
widget.product['mo_ta'] ?? 'Không có mô tả',
    style: TextStyle(fontSize: 16, color: Colors.black87),
    textAlign: TextAlign.justify,
  ),
),
SizedBox(height: 16),

              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: addToCart,
                  child: Text('Thêm vào giỏ hàng'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
