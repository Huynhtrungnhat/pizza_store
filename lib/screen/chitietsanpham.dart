import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/login/login.dart';
import 'package:pizza_store/models/sanphamcart.dart';
import 'package:pizza_store/models/sanphammodel.dart';
import 'package:pizza_store/statusgiohang/loadsave.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../navigationbottom/home_navigationbar.dart';

class ProductDetailPage extends StatefulWidget {

  final Map<String, dynamic> product; 

  ProductDetailPage({super.key, required this.product});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;

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


  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    return isLoggedIn;
  }

  void decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  void addToCart(String displayPrice) async {
    bool isLoggedIn = await checkLoginStatus();

    if (!isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } else {
      Product product = Product(
        ma_san_pham:widget.product['ma_san_pham'] ,
        ten_san_pham: widget.product['ten_san_pham'],
        gia: double.tryParse(displayPrice) ?? 0.0, 
        so_luong_ton_kho: quantity,
        hinh_anh: widget.product['hinh_anh'],
        mo_ta: widget.product['mo_ta'] ?? '',
      );
      cart.addsanpham(product);
      await saveCartToSharedPreferences(cart.items);
      Navigator.pushAndRemoveUntil(context,MaterialPageRoute( builder: (context) => CurveBar(),
    ),
    (route) => false, 
  );
    }
  }

  @override
  Widget build(BuildContext context) {
    int stock = widget.product['so_luong_ton_kho'] ?? 0;
    final numberFormat = NumberFormat("#,##0", "vi_VN");

    String formattedPrice = numberFormat.format(double.tryParse(widget.product['gia']) ?? 0.0);

    String displayPrice = formattedPrice;
    String discountInfo = '';

    if (widget.product['loai_khuyen_mai'] == 'GIATRI' && widget.product['gia_tri_khuyen_mai'] != null) {

      double originalPrice = double.tryParse(widget.product['gia']) ?? 0.0;
      double discountValue = double.tryParse(widget.product['gia_tri_khuyen_mai']) ?? 0.0;
      double discountedPrice = originalPrice - discountValue;
      displayPrice = numberFormat.format(discountedPrice); 
      discountInfo = 'Giảm sốc: ${numberFormat.format(discountValue)} VND';
    } 
    else if (widget.product['discountPercentage'] != null && widget.product['discountPercentage'] > 0)
     {
      double originalPrice = double.tryParse(widget.product['gia']) ?? 0.0;
      double discountedPrice = originalPrice * (1 - widget.product['discountPercentage'] / 100);
      displayPrice = numberFormat.format(discountedPrice); 
      discountInfo = 'Giảm: ${widget.product['discountPercentage']}%';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết sản phẩm"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 500,
              child: Image.network(
                '${AppConstants.BASE_URL}${widget.product['hinh_anh']}',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                widget.product['ten_san_pham'],
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text('Giá: ', style: TextStyle(color: Colors.red, fontSize: 20)),
                Text('$displayPrice VND', style: TextStyle(color: Colors.red, fontSize: 20)),
                if (discountInfo.isNotEmpty && displayPrice != formattedPrice) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    discountInfo,
                    style: TextStyle(color: Colors.red, fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                ),
              ],

              ],
            ),
            SizedBox(height: 8),
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
            SizedBox(height: 8),
            Text(
              'Mô tả :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                widget.product['mo_ta'] ?? 'Không có mô tả',
                style: TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: 18),
            Center(
              child: ElevatedButton(
                onPressed: () => addToCart(displayPrice),
                child: Text('Thêm vào giỏ hàng'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
