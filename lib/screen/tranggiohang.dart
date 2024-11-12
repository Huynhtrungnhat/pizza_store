import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pizza_store/api/controller.dart';
import 'package:pizza_store/models/sanphamcart.dart';
import 'package:pizza_store/navigationbottom/home_navigationbar.dart';
import 'package:pizza_store/screen/trangThanhToan.dart';


class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double discount = 0.0;
  double _rotation = 0.0;
  double _fontSize = 12.0;
  Color _textColor = Colors.black;

  double getTotalAfterDiscount() {
    double totalPrice = cart.getTotalPrice();
    double discountAmount = totalPrice * (discount / 100);
    return totalPrice - discountAmount;
  }

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    setState(() {
      cart.loadCartFromSharedPreferences();
    });
  }

  void _rotateImage() {
    setState(() {
      _rotation += 1.0;
      _fontSize = _fontSize == 12.0 ? 16.0 : 12.0;
      _textColor = _textColor == Colors.black ? Colors.red : Colors.black;
    });
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat("#,##0.000", "vi_VN");

    return Scaffold(
      appBar: AppBar(
        title: Text("Giỏ hàng"),
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _rotateImage,
                    child: AnimatedRotation(
                      turns: _rotation,
                      duration: Duration(seconds: 1),
                      child: Image.asset(
                        "assets/images/giohangtrong.jpg",
                        width: 300,
                      ),
                    ),
                  ),
                  AnimatedDefaultTextStyle(
                    style: TextStyle(
                      fontSize: _fontSize,
                      color: _textColor,
                    ),
                    duration: Duration(milliseconds: 500),
                    child: Text(
                      'Hiện tại bạn chưa có sản phẩm nào trong giỏ hàng.\nHãy dạo một vòng trang chủ sản phẩm để chọn được sản phẩm nhé.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10), // Thêm khoảng cách
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CurveBar(),
                        ),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Tiếp Tục chọn món',
                        style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                var item = cart.items[index];
                return ListTile(
                  title: Text(item.ten_san_pham,
                      maxLines: 3, overflow: TextOverflow.ellipsis),
                  subtitle: Text(
                      '${numberFormat.format(item.gia)} VND x ${item.so_luong_ton_kho}'),
                  leading: Image.network(
                    '${AppConstants.BASE_URL}${item.hinh_anh}',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            cart.updateQuantity(
                                item, item.so_luong_ton_kho - 1);
                          });
                        },
                      ),
                      Text('${item.so_luong_ton_kho}'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            cart.updateQuantity(
                                item, item.so_luong_ton_kho + 1);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: cart.items.isEmpty ? 0.9 : 1.0,
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: cart.items.isEmpty
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrangThanhToan(),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Thanh Toán',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
